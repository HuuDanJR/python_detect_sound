class AddColumnToSlide < ActiveRecord::Migration[6.0]
  def change
    add_column :slides, :description, :string, :limit => 5000
    add_column :slides, :is_show, :boolean, default: 1
  end
end
