class CreateOfferReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :offer_reactions do |t|
      t.integer :reaction_type
      t.references :user, index: true
      t.references :offer, index: true

      t.timestamps
    end
  end
end
