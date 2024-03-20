class ChangePreviousMisconductFields < ActiveRecord::Migration[7.0]
  change_table :referrals, bulk: true do |t|
    reversible do |dir|
      dir.up do
        if t.column_exists?(:previous_misconduct_details_incomplete_at)
          t.remove :previous_misconduct_details_incomplete_at
        end

        t.remove :previous_misconduct_deferred_at if t.column_exists?(:previous_misconduct_deferred_at)
        t.remove :previous_misconduct_completed_at if t.column_exists?(:previous_misconduct_completed_at)
        t.string :previous_misconduct_format unless t.column_exists?(:previous_misconduct_format)
        t.boolean :previous_misconduct_complete unless t.column_exists?(:previous_misconduct_complete)
      end

      dir.down do
        unless t.column_exists?(:previous_misconduct_details_incomplete_at)
          t.datetime :previous_misconduct_details_incomplete_at
        end

        t.datetime :previous_misconduct_deferred_at unless t.column_exists?(:previous_misconduct_deferred_at)
        t.datetime :previous_misconduct_completed_at unless t.column_exists?(:previous_misconduct_completed_at)
        t.remove :previous_misconduct_format if t.column_exists?(:previous_misconduct_format)
        t.remove :previous_misconduct_complete if t.column_exists?(:previous_misconduct_complete)
      end
    end
  end
end
