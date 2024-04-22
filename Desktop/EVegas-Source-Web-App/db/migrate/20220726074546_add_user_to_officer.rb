class AddUserToOfficer < ActiveRecord::Migration[6.0]
  def change
    add_reference :officers, :user, index: true , null: true
  end
end
