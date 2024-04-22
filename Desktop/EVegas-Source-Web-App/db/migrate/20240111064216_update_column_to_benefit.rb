class UpdateColumnToBenefit < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :benefits do |t|
        dir.up { t.change :name, :string, limit: 500 }
        dir.down { t.change :name, :string, limit: 255, default: "" }
      end
    end
  end
end
