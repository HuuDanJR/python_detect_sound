class AddColumnNationalityToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :nationality, :string
  end
end
