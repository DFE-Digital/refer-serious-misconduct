TERRAFILE_VERSION=0.8
ARM_TEMPLATE_TAG=1.1.10
RG_TAGS={"Product" : "Refer Serious Misconduct"}
REGION=UK South
SERVICE_NAME=refer-serious-misconduct
SERVICE_SHORT=rsm
DOCKER_REPOSITORY=ghcr.io/dfe-digital/refer-serious-misconduct

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
	$(eval NAME_ENV=${DEPLOY_ENV})
	$(eval RESOURCE_ENV=${ENV_SHORT})

.PHONY: test
test:
	$(eval DEPLOY_ENV=test)
	$(eval AZURE_SUBSCRIPTION=s165-teachingqualificationsservice-test)
	$(eval RESOURCE_NAME_PREFIX=s165t01)
	$(eval ENV_SHORT=ts)
	$(eval ENV_TAG=test)
	$(eval NAME_ENV=${DEPLOY_ENV})
	$(eval RESOURCE_ENV=${ENV_SHORT})

.PHONY: preprod
preprod:
	$(eval DEPLOY_ENV=preprod)
	$(eval AZURE_SUBSCRIPTION=s165-teachingqualificationsservice-test)
	$(eval RESOURCE_NAME_PREFIX=s165t01)
	$(eval ENV_SHORT=pp)
	$(eval ENV_TAG=pre-prod)
	$(eval NAME_ENV=${DEPLOY_ENV})
	$(eval RESOURCE_ENV=${ENV_SHORT})

.PHONY: production
production:
	$(eval DEPLOY_ENV=production)
	$(eval AZURE_SUBSCRIPTION=s165-teachingqualificationsservice-production)
	$(eval RESOURCE_NAME_PREFIX=s165p01)
	$(eval ENV_SHORT=pd)
	$(eval ENV_TAG=prod)
	$(eval AZURE_BACKUP_STORAGE_ACCOUNT_NAME=s165p01rsmdbbackuppd)
	$(eval AZURE_BACKUP_STORAGE_CONTAINER_NAME=rsm)
	$(eval NAME_ENV=${DEPLOY_ENV})
	$(eval RESOURCE_ENV=${ENV_SHORT})
	$(eval CONSOLE_OPTIONS=--sandbox )

.PHONY: review-init
review-init:
	$(if $(pr_id), , $(error Missing environment variable "pr_id"))
	$(eval ENV_TAG=dev)

.PHONY: review
review: review-init set-azure-resource-group-tags
	$(eval DEPLOY_ENV=review)
	$(eval AZURE_SUBSCRIPTION=s165-teachingqualificationsservice-development)
	$(eval RESOURCE_NAME_PREFIX=s165d01)
	$(eval ENV_SHORT=rv)
	$(eval env=-pr-$(pr_id))
	$(eval backend_config=-backend-config="key=review/review$(env).tfstate")
	$(eval export TF_VAR_resource_group_tags=$(RG_TAGS))
	$(eval export TF_VAR_app_suffix=$(env))
	$(eval export TF_VAR_resource_group_name=s165d01-rsm-review$(env)-rg)
	$(eval export TF_VAR_allegations_storage_account_name=s165d01rsmallegr$(pr_id))
	$(eval NAME_ENV=${DEPLOY_ENV}${env})
	$(eval RESOURCE_ENV=${DEPLOY_ENV}${env})

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

set-azure-resource-group-tags: ##Tags that will be added to resource group on it's creation in ARM template
	$(eval RG_TAGS=$(shell echo '{"Portfolio": "Early Years and Schools Group", "Parent Business":"Teacher Misconduct Unit", "Product" : "Refer Serious Misconduct", "Service Line": "Teaching Workforce", "Service": "Teacher Training and Qualifications", "Service Offering": "Refer Serious Misconduct", "Environment" : "$(ENV_TAG)"}' | jq . ))

set-azure-template-tag:
	$(eval ARM_TEMPLATE_TAG=1.1.0)

.PHONY: read-keyvault-config
read-keyvault-config:
	$(eval KEY_VAULT_NAME=$(shell jq -r '.key_vault_name' terraform/workspace_variables/$(DEPLOY_ENV).tfvars.json))
	$(eval KEY_VAULT_SECRET_NAME=INFRASTRUCTURE)

read-deployment-config:
	$(eval POSTGRES_DATABASE_NAME="$(RESOURCE_NAME_PREFIX)-rsm-$(DEPLOY_ENV)${var.app_suffix}-psql-db")
	$(eval POSTGRES_SERVER_NAME="$(RESOURCE_NAME_PREFIX)-rsm-$(DEPLOY_ENV)${var.app_suffix}-psql.postgres.database.azure.com")

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
	export TF_LOG=DEBUG
	terraform -chdir=terraform plan -var-file workspace_variables/${DEPLOY_ENV}.tfvars.json

terraform-apply: terraform-init
	terraform -chdir=terraform apply -var-file workspace_variables/${DEPLOY_ENV}.tfvars.json ${AUTO_APPROVE}

terraform-destroy: terraform-init
	terraform -chdir=terraform destroy -var-file workspace_variables/${DEPLOY_ENV}.tfvars.json ${AUTO_APPROVE}

deploy-azure-resources: set-azure-account set-azure-template-tag set-azure-resource-group-tags# make dev deploy-azure-resources AUTO_APPROVE=1
	$(if $(AUTO_APPROVE), , $(error can only run with AUTO_APPROVE))
	az deployment sub create --name "resourcedeploy-rsm-$(shell date +%Y%m%d%H%M%S)" -l "West Europe" --template-uri "https://raw.githubusercontent.com/DFE-Digital/tra-shared-services/${ARM_TEMPLATE_TAG}/azure/resourcedeploy.json" \
		--parameters "resourceGroupName=${RESOURCE_NAME_PREFIX}-rsm-${ENV_SHORT}-rg" 'tags=${RG_TAGS}' \
			"tfStorageAccountName=${RESOURCE_NAME_PREFIX}rsmtfstate${ENV_SHORT}" "tfStorageContainerName=rsm-tfstate" \
			"dbBackupStorageAccountName=${AZURE_BACKUP_STORAGE_ACCOUNT_NAME}" "dbBackupStorageContainerName=${AZURE_BACKUP_STORAGE_CONTAINER_NAME}" \
			"keyVaultName=${RESOURCE_NAME_PREFIX}-rsm-${ENV_SHORT}-kv"

validate-azure-resources: set-azure-account set-azure-template-tag set-azure-resource-group-tags# make dev validate-azure-resources
	az deployment sub create --name "resourcedeploy-rsm-$(shell date +%Y%m%d%H%M%S)" -l "West Europe" --template-uri "https://raw.githubusercontent.com/DFE-Digital/tra-shared-services/${ARM_TEMPLATE_TAG}/azure/resourcedeploy.json" \
		--parameters "resourceGroupName=${RESOURCE_NAME_PREFIX}-rsm-${ENV_SHORT}-rg" 'tags=${RG_TAGS}' \
			"tfStorageAccountName=${RESOURCE_NAME_PREFIX}rsmtfstate${ENV_SHORT}" "tfStorageContainerName=rsm-tfstate" \
			"dbBackupStorageAccountName=${AZURE_BACKUP_STORAGE_ACCOUNT_NAME}" "dbBackupStorageContainerName=${AZURE_BACKUP_STORAGE_CONTAINER_NAME}" \
			"keyVaultName=${RESOURCE_NAME_PREFIX}-rsm-${ENV_SHORT}-kv" \
		--what-if

domain-azure-resources: set-azure-account set-azure-template-tag set-azure-resource-group-tags# make domain domain-azure-resources AUTO_APPROVE=1
	$(if $(AUTO_APPROVE), , $(error can only run with AUTO_APPROVE))
	az deployment sub create -l "West Europe" --template-uri "https://raw.githubusercontent.com/DFE-Digital/tra-shared-services/${ARM_TEMPLATE_TAG}/azure/resourcedeploy.json" \
		--parameters "resourceGroupName=${RESOURCE_NAME_PREFIX}-rsmdomains-rg" 'tags=${RG_TAGS}' "environment=${DEPLOY_ENV}" \
			"tfStorageAccountName=${RESOURCE_NAME_PREFIX}rsmdomainstf" "tfStorageContainerName=rsmdomains-tf"  "keyVaultName=${RESOURCE_NAME_PREFIX}-rsmdomains-kv"

az-console: set-azure-account
	az container exec \
		--name=${RESOURCE_NAME_PREFIX}-rsm-${NAME_ENV}-wkr-cg \
		--resource-group=${RESOURCE_NAME_PREFIX}-rsm-${RESOURCE_ENV}-rg \
		--exec-command="bundle exec rails c ${CONSOLE_OPTIONS}-- --noautocomplete"

# AKS make config
.PHONY: aks-review
aks-review: test-cluster
	$(if ${PR_NUMBER},,$(error Missing PR_NUMBER))
	$(eval ENVIRONMENT=pr-${PR_NUMBER})
	$(eval include global_config/review.sh)

bin/terrafile: ## Install terrafile to manage terraform modules
	curl -sL https://github.com/coretech/terrafile/releases/download/v${TERRAFILE_VERSION}/terrafile_${TERRAFILE_VERSION}_$$(uname)_$$(uname -m).tar.gz \
		| tar xz -C ./bin terrafile

aks-set-azure-account:
	[ "${SKIP_AZURE_LOGIN}" != "true" ] && az account set -s ${AZURE_SUBSCRIPTION} || true

composed-variables:
	$(eval RESOURCE_GROUP_NAME=${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-rg)
	$(eval KEYVAULT_NAMES='("${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-app-kv", "${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-inf-kv")')
	$(eval STORAGE_ACCOUNT_NAME=${AZURE_RESOURCE_PREFIX}${SERVICE_SHORT}${CONFIG_SHORT}tfsa)
	$(eval LOG_ANALYTICS_WORKSPACE_NAME=${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-log)

get-cluster-credentials: set-azure-account
	az aks get-credentials --overwrite-existing -g ${CLUSTER_RESOURCE_GROUP_NAME} -n ${CLUSTER_NAME}
	kubelogin convert-kubeconfig -l $(if ${GITHUB_ACTIONS},spn,azurecli)

test-cluster:
	$(eval CLUSTER_RESOURCE_GROUP_NAME=s189t01-tsc-ts-rg)
	$(eval CLUSTER_NAME=s189t01-tsc-test-aks)

set-what-if:
	$(eval WHAT_IF=--what-if)

arm-deployment: composed-variables aks-set-azure-account
	$(if ${DISABLE_KEYVAULTS},, $(eval KV_ARG=keyVaultNames=${KEYVAULT_NAMES}))
	$(if ${ENABLE_KV_DIAGNOSTICS}, $(eval KV_DIAG_ARG=enableDiagnostics=${ENABLE_KV_DIAGNOSTICS} logAnalyticsWorkspaceName=${LOG_ANALYTICS_WORKSPACE_NAME}),)

	az deployment sub create --name "resourcedeploy-tsc-$(shell date +%Y%m%d%H%M%S)" \
		-l "${REGION}" --template-uri "https://raw.githubusercontent.com/DFE-Digital/tra-shared-services/${ARM_TEMPLATE_TAG}/azure/resourcedeploy.json" \
		--parameters "resourceGroupName=${RESOURCE_GROUP_NAME}" 'tags=${RG_TAGS}' \
		"tfStorageAccountName=${STORAGE_ACCOUNT_NAME}" "tfStorageContainerName=terraform-state" \
		${KV_ARG} \
		${KV_DIAG_ARG} \
		"enableKVPurgeProtection=${KV_PURGE_PROTECTION}" \
		${WHAT_IF}

deploy-arm-resources: arm-deployment ## Validate ARM resource deployment. Usage: make domains validate-arm-resources

validate-arm-resources: set-what-if arm-deployment ## Validate ARM resource deployment. Usage: make domains validate-arm-resources

aks-terraform-init: composed-variables bin/terrafile aks-set-azure-account
	$(if ${DOCKER_IMAGE_TAG}, , $(eval DOCKER_IMAGE_TAG=main))

	./bin/terrafile -p terraform/application/vendor/modules -f terraform/application/config/$(CONFIG)_Terrafile
	terraform -chdir=terraform/application init -upgrade -reconfigure \
		-backend-config=resource_group_name=${RESOURCE_GROUP_NAME} \
		-backend-config=storage_account_name=${STORAGE_ACCOUNT_NAME} \
		-backend-config=key=${ENVIRONMENT}_kubernetes.tfstate

	$(eval export TF_VAR_environment=${ENVIRONMENT})
	$(eval export TF_VAR_resource_group_name=${RESOURCE_GROUP_NAME})
	$(eval export TF_VAR_azure_resource_prefix=${AZURE_RESOURCE_PREFIX})
	$(eval export TF_VAR_config=${CONFIG})
	$(eval export TF_VAR_config_short=${CONFIG_SHORT})
	$(eval export TF_VAR_service_name=${SERVICE_NAME})
	$(eval export TF_VAR_service_short=${SERVICE_SHORT})
	$(eval export TF_VAR_docker_image=${DOCKER_REPOSITORY}:${DOCKER_IMAGE_TAG})

aks-terraform-plan: aks-terraform-init
	terraform -chdir=terraform/application plan -var-file "config/${CONFIG}.tfvars.json"

aks-terraform-apply: aks-terraform-init
	terraform -chdir=terraform/application apply -var-file "config/${CONFIG}.tfvars.json" ${AUTO_APPROVE}

aks-terraform-destroy: aks-terraform-init
	terraform -chdir=terraform/application destroy -var-file "config/${CONFIG}.tfvars.json" ${AUTO_APPROVE}
