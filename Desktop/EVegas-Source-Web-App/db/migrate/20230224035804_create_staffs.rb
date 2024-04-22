class CreateStaffs < ActiveRecord::Migration[6.0]
  def change
    create_table :staffs do |t|
      t.string :name, limit: 255, default: ""
      t.string :nick_name, limit: 255, default: ""
      t.boolean :gender, default: 1
      t.string :position
      t.string :code, limit: 6, default: ""

      t.timestamps
    end
  end
end
