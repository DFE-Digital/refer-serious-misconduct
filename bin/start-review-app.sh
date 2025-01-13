#! /bin/bash

bundle exec rails db:schema_load_or_migrate
bundle exec rails runner "%i(eligibility_screener referral_form).each {|flag| FeatureFlags::FeatureFlag.activate(flag)}"
bundle exec rails server -b 0.0.0.0
