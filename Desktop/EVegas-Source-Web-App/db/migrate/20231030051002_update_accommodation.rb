class UpdateAccommodation < ActiveRecord::Migration[6.0]
  def change
    remove_column :accommodations, :name
    remove_column :accommodations, :time_pick
    add_column :accommodations, :time_end, :datetime, default: DateTime.now
  end
end
