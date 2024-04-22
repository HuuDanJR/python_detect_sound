class CreateOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :offers do |t|
      t.string :title, limit: 512, default: ""
      t.string :title_vi, limit: 512, default: ""
      t.string :title_kr, limit: 512, default: ""
      t.string :title_cn, limit: 512, default: ""
      t.text :description
      t.text :description_vi
      t.text :description_kr
      t.text :description_cn
      t.string :url_news, limit: 512, default: ""
      t.datetime :publish_date, default: DateTime.now
      t.boolean :is_highlight, default: 0
      t.integer :offer_type, default: 1
      t.references :attachment, index: true

      t.timestamps
    end
  end
end
