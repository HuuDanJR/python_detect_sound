class AddIsSendAndTimeToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :is_send, :boolean, default: 0
    add_column :messages, :time_send, :datetime
    add_reference :messages, :attachments, index: true
  end
end
