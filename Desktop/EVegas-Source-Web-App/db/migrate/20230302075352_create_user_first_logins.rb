class CreateUserFirstLogins < ActiveRecord::Migration[6.0]
  def change
    create_table :user_first_logins do |t|
      t.references :user, index: true
      t.timestamps
    end
  end
end
