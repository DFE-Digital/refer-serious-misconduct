#! /bin/bash

/usr/sbin/sshd
export DISABLE_DATABASE_ENVIRONMENT_CHECK=1
# Get environment variables to show up in SSH session
echo -e "Environment variables:\n$(printenv)"
eval $(printenv | awk -F= '{print "export " "\""$1"\"""=""\""$2"\"" }' >> /etc/profile)
bundle exec rails db:schema_load_or_migrate && bundle exec rails server -b 0.0.0.0
