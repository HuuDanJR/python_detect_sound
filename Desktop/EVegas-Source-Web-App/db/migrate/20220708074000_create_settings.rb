class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :setting_key, limit: 255
      t.string :setting_value, limit: 255
      t.string :description, limit: 255
      t.timestamps
    end
  end
end
