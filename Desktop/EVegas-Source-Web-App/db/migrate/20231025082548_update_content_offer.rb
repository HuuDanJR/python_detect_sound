class UpdateContentOffer < ActiveRecord::Migration[6.0]
  def change
    change_column :offers, :description, :text, limit: 16.megabytes - 1
    change_column :offers, :description_ja, :text, limit: 16.megabytes - 1
    change_column :offers, :description_kr, :text, limit: 16.megabytes - 1
    change_column :offers, :description_cn, :text, limit: 16.megabytes - 1
  end
end
