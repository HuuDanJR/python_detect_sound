class ChangeDefaultDateOffer < ActiveRecord::Migration[6.0]
  def change
    change_column :offers, :publish_date, :datetime, default: ""
    change_column :offers, :time_end, :datetime, default: ""
  end
end
