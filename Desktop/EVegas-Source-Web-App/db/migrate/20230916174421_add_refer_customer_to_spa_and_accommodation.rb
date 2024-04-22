class AddReferCustomerToSpaAndAccommodation < ActiveRecord::Migration[6.0]
  def change
    add_reference :spas, :customer, index: true
    add_reference :accommodations, :customer, index: true
  end
end
