class AddAttachmentToTermService < ActiveRecord::Migration[6.0]
  def change
    add_reference :term_services, :attachment, index: true
  end
end
