class CreateLogMails < ActiveRecord::Migration[6.0]
  def change
    create_table :log_mails do |t|
      t.string :email, limit: 512, default: ""
      t.text :content
      t.string :log_type, limit: 255, default: ""
      t.boolean :log_type_send, default: false
      t.timestamps
    end
  end
end
