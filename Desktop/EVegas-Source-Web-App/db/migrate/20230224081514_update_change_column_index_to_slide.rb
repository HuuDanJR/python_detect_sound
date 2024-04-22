class UpdateChangeColumnIndexToSlide < ActiveRecord::Migration[6.0]
  def change
    rename_column :slides, :index, :slide_index
  end
end
