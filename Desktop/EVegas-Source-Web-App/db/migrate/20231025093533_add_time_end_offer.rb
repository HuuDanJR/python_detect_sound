class AddTimeEndOffer < ActiveRecord::Migration[6.0]
  def change
    add_column :offers, :time_end, :datetime, default: DateTime.now
    change_column :offers, :offer_type, :integer, default: 2
  end
end
