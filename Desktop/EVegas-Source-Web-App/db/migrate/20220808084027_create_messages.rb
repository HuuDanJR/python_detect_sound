class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :content, limit: 255, default: ""
      t.timestamps
    end
  end
end
