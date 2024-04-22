class AddMultiLanguageToBenefit < ActiveRecord::Migration[6.0]
  def change
    add_column :benefits, :name_ja, :string, limit: 500, default: ""
    add_column :benefits, :description_ja, :string, limit: 4000, default: ""
    add_column :benefits, :name_kr, :string, limit: 500, default: ""
    add_column :benefits, :description_kr, :string, limit: 4000, default: ""
    add_column :benefits, :name_cn, :string, limit: 500, default: ""
    add_column :benefits, :description_cn, :string, limit: 4000, default: ""
  end
end
