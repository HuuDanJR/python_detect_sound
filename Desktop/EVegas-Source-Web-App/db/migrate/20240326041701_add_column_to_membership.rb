class AddColumnToMembership < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :color_milestone, :string, limit: 255, default: ""
    add_column :memberships, :is_show_milestone, :boolean, null: false, default: 0
  end
end
