class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.string :satisfaction_rating, null: false
      t.text :improvement_suggestion, null: false
      t.boolean :contact_permission_given, null: false
      t.string :email

      t.timestamps
    end
  end
end
