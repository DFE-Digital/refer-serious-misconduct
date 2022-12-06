class AddTeachingSomewhereElsetoReferral < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :teaching_somewhere_else, :string
  end
end
