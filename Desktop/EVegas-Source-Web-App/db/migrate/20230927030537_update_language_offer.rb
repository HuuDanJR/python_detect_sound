class UpdateLanguageOffer < ActiveRecord::Migration[6.0]
  def change
    rename_column :offers, :title_vi, :title_ja
    rename_column :offers, :description_vi, :description_ja
  end
end
