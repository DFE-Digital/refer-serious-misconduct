class CreateUploads < ActiveRecord::Migration[7.0]
  def change
    create_table :uploads do |t|
      t.string "section", null: false
      t.references :uploadable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
