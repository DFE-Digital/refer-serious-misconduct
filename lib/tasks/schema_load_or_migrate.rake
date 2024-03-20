db_namespace =
  namespace(:db) do
    desc "Runs schema:load if database does not exist, or runs migrations if it does"
    task schema_load_or_migrate: :load_config do
      ActiveRecord::Base
        .configurations
        .configs_for(env_name: Rails.env)
        .each do |db_config|
          ActiveRecord::Base.establish_connection(db_config.configuration_hash)
          if ActiveRecord::SchemaMigration.new(ActiveRecord::Base.connection).table_exists?
            puts "Invoking db:migrate"
            db_namespace["migrate"].invoke
          else
            puts "Invoking db:schema:load"
            db_namespace["schema:load"].invoke
          end
        end
    rescue ActiveRecord::ConcurrentMigrationError
      # Do nothing
    end
  end
