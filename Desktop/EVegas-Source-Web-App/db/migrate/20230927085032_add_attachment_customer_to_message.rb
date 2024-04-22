class AddAttachmentCustomerToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :customer_attachment, :bigint
  end
end
