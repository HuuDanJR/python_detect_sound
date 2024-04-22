class AddStatusToAccommodationAndSpa < ActiveRecord::Migration[6.0]
  def change
    add_column :spas, :status, :integer, default: 1
    add_column :accommodations, :status, :integer, default: 1
  end
end
