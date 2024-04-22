class CreateMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.string :name, limit: 255
      t.string :sub, limit: 255
      t.integer :point
      t.timestamps
    end
  end
end
