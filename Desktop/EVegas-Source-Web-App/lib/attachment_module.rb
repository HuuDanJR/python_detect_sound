require 'digest'

module AttachmentModule
  include CommonModule
  include DaoModule

  ATTACHMENT_ATTRIBUTE = ClassAttribute.new
  ATTACHMENT_ATTRIBUTE.clazz = Attachment
  ATTACHMENT_ATTRIBUTE.object_key = "attachment"

  def check_attachment_upload(_id = nil)
    result = ResultHandler.new
    file_prop = params[:file]
    if is_blank(file_prop)
      result.set_error_data(:bad_request, I18n.t('messages.attachment_file_required'))
      return result
    end

    return result
  end

  def get_attachments_from_request(_obj)
    if _obj.nil?
      return []
    end

    list = []
    i = 0

    loop do
      attachment = Attachment.new
      file = _obj[i]
      break if file.nil?
      attachment.file = file
      attachment.category = get_extension_file_upload(file)
      attachment.name = file.original_filename
      attachment.file_hash = Digest::MD5.hexdigest(file.read)
      list.push(attachment)
      i += 1
    end

    return list
  end

  def create_attachment_file(attachment)
    return attachment.save
  end

  def get_attachment_exist(hash_file_data)
    return Attachment.where('hash = ?', hash_file_data).first
  end

  def get_attachment_from_request(file)
    if file.nil?
      return nil
    end
    
    attachment = Attachment.new
    attachment.file = file
    attachment.category = get_extension_file_upload(file)
    attachment.name = file.original_filename
    attachment.file_hash = Digest::MD5.hexdigest(file.read)

    return attachment
  end

  def get_attachment_base64(image_base64, customer_number)
    if image_base64.nil?
      return nil
    end
    
    attachment = Attachment.new
    attachment.image_data(image_base64)
    # attachment.file = file
    attachment.category = get_extension_file_upload(attachment.file)
    attachment.name = customer_number #attachment.file.original_filename
    attachment.file_hash = Digest::MD5.hexdigest(attachment.file.read)

    return attachment
  end

  def upload_attachment(attachment)
    result = ResultHandler.new
    attachment.save!

    if !attachment.nil?
      result.set_success_data(:ok, attachment)
    else
      
      result.set_success_data(:bad_request, "Lỗi upload")
    end

    return result
  end
  
end