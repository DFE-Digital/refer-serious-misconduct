class ChangeOrganisationFields < ActiveRecord::Migration[7.0]
  change_table :organisations, bulk: true do |t|
    reversible do |dir|
      dir.up do
        t.remove :completed_at if t.column_exists?(:completed_at)
        t.boolean :complete unless t.column_exists?(:complete)
      end

      dir.down do
        t.datetime :completed_at unless t.column_exists?(:completed_at)
        t.remove :complete if t.column_exists?(:complete)
      end
    end
  end
end
