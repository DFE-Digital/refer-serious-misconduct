class CreateValidationErrors < ActiveRecord::Migration[7.0]
  def change
    create_table :validation_errors do |t|
      t.string "form_object"
      t.jsonb "details"

      t.timestamps
    end
  end
end
