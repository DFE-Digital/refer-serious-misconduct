#! /bin/bash

/usr/sbin/sshd
export DISABLE_DATABASE_ENVIRONMENT_CHECK=1
bundle exec rails db:schema_load_or_migrate && bundle exec rails server -b 0.0.0.0
