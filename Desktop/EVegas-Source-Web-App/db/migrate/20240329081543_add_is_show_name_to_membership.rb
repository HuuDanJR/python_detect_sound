class AddIsShowNameToMembership < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :is_show_name, :boolean, null: false, default: 0
  end
end
