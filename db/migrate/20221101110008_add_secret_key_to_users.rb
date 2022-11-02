class AddSecretKeyToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :secret_key, :string
  end
end
