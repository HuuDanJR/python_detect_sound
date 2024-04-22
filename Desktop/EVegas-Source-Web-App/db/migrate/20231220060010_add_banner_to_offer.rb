class AddBannerToOffer < ActiveRecord::Migration[6.0]
  def change
    add_column :offers, :banner_attachment, :bigint
  end
end
