.DEFAULT_GOAL		:=help
SHELL				:=/bin/bash

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z\.\-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

##@ Set environment and corresponding configuration
.PHONY: dev
dev:
	$(eval DEPLOY_ENV=dev)
	$(eval AZURE_SUBSCRIPTION=s165-teachingqualificationsservice-development)
	$(eval RESOURCE_NAME_PREFIX=s165d01)
	$(eval ENV_SHORT=dv)
	$(eval ENV_TAG=dev)

.PHONY: test
test:
	$(eval DEPLOY_ENV=test)
	$(eval AZURE_SUBSCRIPTION=s165-teachingqualificationsservice-test)
	$(eval RESOURCE_NAME_PREFIX=s165t01)
	$(eval ENV_SHORT=ts)
	$(eval ENV_TAG=test)

.PHONY: preprod
preprod:
	$(eval DEPLOY_ENV=preprod)
	$(eval AZURE_SUBSCRIPTION=s165-teachingqualificationsservice-test)
	$(eval RESOURCE_NAME_PREFIX=s165t01)
	$(eval ENV_SHORT=pp)
	$(eval ENV_TAG=pre-prod)

.PHONY: production
production:
	$(eval DEPLOY_ENV=production)
	$(eval AZURE_SUBSCRIPTION=s165-teachingqualificationsservice-production)
	$(eval RESOURCE_NAME_PREFIX=s165p01)
	$(eval ENV_SHORT=pd)
	$(eval ENV_TAG=prod)
	$(eval AZURE_BACKUP_STORAGE_ACCOUNT_NAME=s165p01aytpdbbackuppd)
	$(eval AZURE_BACKUP_STORAGE_CONTAINER_NAME=aytp)

.PHONY: review
review:
	$(if $(pr_id), , $(error Missing environment variable "pr_id"))
	$(eval DEPLOY_ENV=review)
	$(eval AZURE_SUBSCRIPTION=s165-teachingqualificationsservice-development)
	$(eval env=-pr-$(pr_id))
	$(eval backend_config=-backend-config="key=review/review$(env).tfstate")
	$(eval export TF_VAR_app_suffix=$(env))

.PHONY: domain
domain:
	$(eval DEPLOY_ENV=production)
	$(eval AZURE_SUBSCRIPTION=s165-teachingqualificationsservice-production)
	$(eval RESOURCE_NAME_PREFIX=s165p01)
	$(eval ENV_SHORT=pd)
	$(eval ENV_TAG=prod)


ci:	## Run in automation environment
	$(eval DISABLE_PASSCODE=true)
	$(eval AUTO_APPROVE=-auto-approve)
	$(eval SP_AUTH=true)

tags: ##Tags that will be added to resource group on it's creation in ARM template
	$(eval RG_TAGS=$(shell echo '{"Portfolio": "Early years and Schools Group", "Parent Business":"Teaching Regulation Agency", "Product" : "Access Your Teaching Profile", "Service Line": "Teaching Workforce", "Service": "Teacher Services", "Service Offering": "Access Your Teaching Profile", "Environment" : "$(ENV_TAG)"}' | jq . ))

.PHONY: read-keyvault-config
read-keyvault-config:
	$(eval KEY_VAULT_NAME=$(shell jq -r '.key_vault_name' terraform/workspace_variables/$(DEPLOY_ENV).tfvars.json))
	$(eval KEY_VAULT_SECRET_NAME=INFRASTRUCTURE)

read-deployment-config:
	$(eval POSTGRES_DATABASE_NAME="$(RESOURCE_NAME_PREFIX)-aytp-$(DEPLOY_ENV)${var.app_suffix}-psql-db")
	$(eval POSTGRES_SERVER_NAME="$(RESOURCE_NAME_PREFIX)-aytp-$(DEPLOY_ENV)${var.app_suffix}-psql.postgres.database.azure.com")

##@ Query parameter store to display environment variables. Requires Azure credentials
set-azure-account: ${environment}
	echo "Logging on to ${AZURE_SUBSCRIPTION}"
	az account set -s ${AZURE_SUBSCRIPTION}

.PHONY: install-fetch-config
install-fetch-config: ## Install the fetch-config script, for viewing/editing secrets in Azure Key Vault
	[ ! -f bin/fetch_config.rb ] \
		&& curl -s https://raw.githubusercontent.com/DFE-Digital/bat-platform-building-blocks/master/scripts/fetch_config/fetch_config.rb -o bin/fetch_config.rb \
		&& chmod +x bin/fetch_config.rb \
		|| true

edit-keyvault-secret: read-keyvault-config install-fetch-config set-azure-account
	bin/fetch_config.rb -s azure-key-vault-secret:${KEY_VAULT_NAME}/${KEY_VAULT_SECRET_NAME} \
		-e -d azure-key-vault-secret:${KEY_VAULT_NAME}/${KEY_VAULT_SECRET_NAME} -f yaml -c

create-keyvault-secret: read-keyvault-config install-fetch-config set-azure-account
	bin/fetch_config.rb -s azure-key-vault-secret:${KEY_VAULT_NAME}/${KEY_VAULT_SECRET_NAME} \
		-i -e -d azure-key-vault-secret:${KEY_VAULT_NAME}/${KEY_VAULT_SECRET_NAME} -f yaml -c

print-keyvault-secret: read-keyvault-config install-fetch-config set-azure-account
	bin/fetch_config.rb -s azure-key-vault-secret:${KEY_VAULT_NAME}/${KEY_VAULT_SECRET_NAME} -f yaml

validate-keyvault-secret: read-keyvault-config install-fetch-config set-azure-account
	bin/fetch_config.rb -s azure-key-vault-secret:${KEY_VAULT_NAME}/${KEY_VAULT_SECRET_NAME} -d quiet \
		&& echo Data in ${KEY_VAULT_NAME}/${KEY_VAULT_SECRET_NAME} looks valid

terraform-init:
	$(if $(IMAGE_TAG), , $(eval export IMAGE_TAG=main))
	[[ "${SP_AUTH}" != "true" ]] && az account set -s $(AZURE_SUBSCRIPTION) || true
	terraform -chdir=terraform init -backend-config workspace_variables/${DEPLOY_ENV}.backend.tfvars $(backend_config) -upgrade -reconfigure

terraform-plan: terraform-init
	terraform -chdir=terraform plan -var-file workspace_variables/${DEPLOY_ENV}.tfvars.json

terraform-apply: terraform-init
	terraform -chdir=terraform apply -var-file workspace_variables/${DEPLOY_ENV}.tfvars.json ${AUTO_APPROVE}

terraform-destroy: terraform-init
	terraform -chdir=terraform destroy -var-file workspace_variables/${DEPLOY_ENV}.tfvars.json ${AUTO_APPROVE}

deploy-azure-resources: set-azure-account tags # make dev deploy-azure-resources CONFIRM_DEPLOY=1
	$(if $(CONFIRM_DEPLOY), , $(error can only run with CONFIRM_DEPLOY))
	az deployment sub create -l "West Europe" --template-uri "https://raw.githubusercontent.com/DFE-Digital/tra-shared-services/main/azure/resourcedeploy.json" --parameters "resourceGroupName=${RESOURCE_NAME_PREFIX}-aytp-${ENV_SHORT}-rg" 'tags=${RG_TAGS}' "environment=${DEPLOY_ENV}" "tfStorageAccountName=${RESOURCE_NAME_PREFIX}aytptfstate${ENV_SHORT}" "tfStorageContainerName=aytp-tfstate" "dbBackupStorageAccountName=${AZURE_BACKUP_STORAGE_ACCOUNT_NAME}" "dbBackupStorageContainerName=${AZURE_BACKUP_STORAGE_CONTAINER_NAME}" "keyVaultName=${RESOURCE_NAME_PREFIX}-aytp-${ENV_SHORT}-kv"

validate-azure-resources: set-azure-account  tags# make dev validate-azure-resources
	az deployment sub create -l "West Europe" --template-uri "https://raw.githubusercontent.com/DFE-Digital/tra-shared-services/main/azure/resourcedeploy.json" --parameters "resourceGroupName=${RESOURCE_NAME_PREFIX}-aytp-${ENV_SHORT}-rg" 'tags=${RG_TAGS}' "environment=${DEPLOY_ENV}" "tfStorageAccountName=${RESOURCE_NAME_PREFIX}aytptfstate${ENV_SHORT}" "tfStorageContainerName=aytp-tfstate" "dbBackupStorageAccountName=${AZURE_BACKUP_STORAGE_ACCOUNT_NAME}" "dbBackupStorageContainerName=${AZURE_BACKUP_STORAGE_CONTAINER_NAME}" "keyVaultName=${RESOURCE_NAME_PREFIX}-aytp-${ENV_SHORT}-kv" --what-if

domain-azure-resources: set-azure-account tags # make domain domain-azure-resources CONFIRM_DEPLOY=1
	$(if $(CONFIRM_DEPLOY), , $(error can only run with CONFIRM_DEPLOY))
	az deployment sub create -l "West Europe" --template-uri "https://raw.githubusercontent.com/DFE-Digital/tra-shared-services/main/azure/resourcedeploy.json" --parameters "resourceGroupName=${RESOURCE_NAME_PREFIX}-aytpdomains-rg" 'tags=${RG_TAGS}' "environment=${DEPLOY_ENV}" "tfStorageAccountName=${RESOURCE_NAME_PREFIX}aytpdomainstf" "tfStorageContainerName=aytpdomains-tf"  "keyVaultName=${RESOURCE_NAME_PREFIX}-aytpdomains-kv"
