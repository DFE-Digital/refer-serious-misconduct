class AddUuidToUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    add_column :users, :uuid, :uuid, default: "gen_random_uuid()", null: false

    add_index :users, :uuid, unique: true
  end
end
