class CreateOfferSubscribers < ActiveRecord::Migration[6.0]
  def change
    create_table :offer_subscribers do |t|
      t.datetime :time_send
      t.boolean :is_send
      t.references :user, index: true
      t.references :offer, index: true
      t.timestamps
    end
  end
end
