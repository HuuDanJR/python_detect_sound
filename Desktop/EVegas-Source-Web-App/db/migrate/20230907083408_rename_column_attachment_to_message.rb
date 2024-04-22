class RenameColumnAttachmentToMessage < ActiveRecord::Migration[6.0]
  def change
    rename_column :messages, :attachments_id, :attachment_id
  end
end
