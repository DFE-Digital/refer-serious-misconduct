class ChangeStringDescriptionsToText < ActiveRecord::Migration[7.0]
  def up
    change_table :referrals, bulk: true do |t|
      t.change :duties_details, :text
      t.change :allegation_details, :text
    end
  end

  def down
    change_table :referrals, bulk: true do |t|
      t.change :duties_details, :string
      t.change :allegation_details, :string
    end
  end
end
