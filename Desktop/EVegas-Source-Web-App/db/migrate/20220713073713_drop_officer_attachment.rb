class DropOfficerAttachment < ActiveRecord::Migration[6.0]
  def change
    drop_table :officer_attachments
  end
end
