class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.integer :age, default: 0
      t.string :card_number, limit: 10, default: ""
      t.decimal :cashless_balance, default: 0
      t.integer :colour, default: 0
      t.string :colour_html, limit: 50, default: ""
      t.decimal :comp_balance, default: 0
      t.integer :comp_status_colour, default: 0
      t.string :comp_status_colour_html, limit: 50, default: ""
      t.string :forename, limit: 50, default: ""
      t.decimal :freeplay_balance, default: 0
      t.string :gender, limit: 10, default: ""
      t.boolean :has_online_account, default: 0
      t.boolean :hide_comp_balance, default: 0
      t.boolean :is_guest, default: 0
      t.decimal :loyalty_balance, default: 0
      t.integer :loyalty_points_available, default: 0
      t.string :membership_type_name, limit: 50, default: ""
      t.string :middle_name, limit: 50, default: ""
      t.integer :number, default: 0
      t.string :player_tier_name, limit: 50, default: ""
      t.string :player_tier_short_code, limit: 50, default: ""
      t.boolean :premium_player, default: 0
      t.string :surname, limit: 50, default: ""
      t.string :title, limit: 10, default: ""
      t.boolean :valid_membership, default: 0
      t.timestamps
    end
  end
end
