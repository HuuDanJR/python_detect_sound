class UpdateDatePickToAccommodation < ActiveRecord::Migration[6.0]
  def change
    change_column :accommodations, :date_pick, :datetime, default: DateTime.now
  end
end
