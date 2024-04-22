class AddAttachmentToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_reference :customers, :attachment, index: true , null: true
  end
end
