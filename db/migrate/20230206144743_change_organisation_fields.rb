class ChangeOrganisationFields < ActiveRecord::Migration[7.0]
  change_table :organisations, bulk: true do |t|
    reversible do |dir|
      dir.up do
        t.remove :completed_at, if_exists: true
        t.boolean :complete, if_not_exists: true
      end

      dir.down do
        t.datetime :completed_at, if_not_exists: true
        t.remove :complete, if_exists: true
      end
    end
  end
end
