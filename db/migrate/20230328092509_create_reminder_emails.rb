class CreateReminderEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :reminder_emails do |t|
      t.references :referral, null: false, foreign_key: true
      t.timestamps
    end
  end
end
