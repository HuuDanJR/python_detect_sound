class AddLanguageToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :language, :string, :limit => 2, default: 'en'
    add_column :users, :setting, :string, default: "{\"notfication\":1,\"darkmode\":0,\"face_id\":0,\"finger\":0}"
  end
end
