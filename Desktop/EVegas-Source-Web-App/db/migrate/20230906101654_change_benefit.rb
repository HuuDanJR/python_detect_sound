class ChangeBenefit < ActiveRecord::Migration[6.0]
  def change
    change_table :benefits do |t|
      t.remove :times
      t.integer :status
    end
  end
end
