class AddUserToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_reference :customers, :user, index: true , null: true
  end
end
