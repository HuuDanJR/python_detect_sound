class UpdateCustomerNumberToCustomer < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :customers do |t|
        dir.up { t.change :card_number, :string, limit: 50 }
        dir.down { t.change :card_number, :string, limit: 10 }
      end
    end
  end
end
