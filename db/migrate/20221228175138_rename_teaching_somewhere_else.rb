class RenameTeachingSomewhereElse < ActiveRecord::Migration[7.0]
  def change
    rename_column :referrals, :teaching_somewhere_else, :working_somewhere_else
  end
end
