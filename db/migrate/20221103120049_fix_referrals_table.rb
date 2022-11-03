# TODO: Delete this file at some point, when all databases in use have migrated
# Also potentially move the `email_known` field before the email_address in `schema.db`
# as postgres doesn't support ordering in migrations

class FixReferralsTable < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      change_table :referrals do |t|
        dir.up do
          t.remove :email_known, if_exists: true
          t.boolean :email_known, if_not_exists: true
          t.remove :boolean, if_exists: true
          t.remove :string, if_exists: true
        end

        dir.down { t.boolean :email_known }
      end
    end
  end
end
