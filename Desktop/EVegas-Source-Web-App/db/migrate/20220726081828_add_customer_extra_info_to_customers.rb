class AddCustomerExtraInfoToCustomers < ActiveRecord::Migration[6.0]
  def up
    add_column :customers, :date_of_birth, :datetime
    add_column :customers, :membership_last_issue_date, :datetime
  end
  def down
    remove_column :customers, :date_of_birth
    remove_column :customers, :membership_last_issue_date
  end
end
