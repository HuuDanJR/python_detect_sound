class AddAttachmentToOfficer < ActiveRecord::Migration[6.0]
  def change
    add_reference :officers, :attachment, index: true , null: true
  end
end
