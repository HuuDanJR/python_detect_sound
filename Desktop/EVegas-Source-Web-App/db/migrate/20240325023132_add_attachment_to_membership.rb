class AddAttachmentToMembership < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :attachment_id, :bigint
  end
end
