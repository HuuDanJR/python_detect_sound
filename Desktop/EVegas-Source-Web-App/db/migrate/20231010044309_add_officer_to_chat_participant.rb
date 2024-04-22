class AddOfficerToChatParticipant < ActiveRecord::Migration[6.0]
  def change
    add_reference :chat_participants, :officer, index: true
  end
end
