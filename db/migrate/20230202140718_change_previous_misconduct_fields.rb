class ChangePreviousMisconductFields < ActiveRecord::Migration[7.0]
  change_table :referrals, bulk: true do |t|
    reversible do |dir|
      dir.up do
        t.remove :previous_misconduct_details_incomplete_at, if_exists: true
        t.remove :previous_misconduct_deferred_at, if_exists: true
        t.remove :previous_misconduct_completed_at, if_exists: true
        t.string :previous_misconduct_format, if_not_exists: true
        t.boolean :previous_misconduct_complete, if_not_exists: true
      end

      dir.down do
        t.datetime :previous_misconduct_details_incomplete_at, if_not_exists: true
        t.datetime :previous_misconduct_deferred_at, if_not_exists: true
        t.datetime :previous_misconduct_completed_at, if_not_exists: true
        t.remove :previous_misconduct_format, if_exists: true
        t.remove :previous_misconduct_complete, if_exists: true
      end
    end
  end
end
