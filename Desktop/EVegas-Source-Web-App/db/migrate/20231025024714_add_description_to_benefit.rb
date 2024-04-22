class AddDescriptionToBenefit < ActiveRecord::Migration[6.0]
  def change
    add_column :benefits, :description, :string, limit: 2000, default: ""
  end
end
