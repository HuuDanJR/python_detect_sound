class Attachment < ApplicationRecord
  mount_uploader :file, AttachmentUploader

  def image_data(base64_data)
    # decode data and create stream on them
    io = AttachmentIo.new(Base64.decode64(base64_data))
    # this will do the thing (file is mounted carrierwave uploader)    
    self.file = io
  end
end
