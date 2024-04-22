require 'digest'
require 'securerandom'

class OfficerImport
  include ActiveModel::Model
  require 'roo'

  attr_accessor :file

  include AttachmentModule

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then
      Csv.new(file.path, nil, :ignore)
    when ".xls" then
      Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then
      Roo::Excelx.new(file.path)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end

  def load_imported_items
    spreadsheet = open_spreadsheet

    @officerList = []
    header = spreadsheet.sheet(0).row(1)
    (2..spreadsheet.sheet(0).last_row).map do |i|
      row = Hash[[header, spreadsheet.sheet(0).row(i)].transpose]
      @officerList.push(OfficerData.new(row["name"], row["date_of_birth"], row["gender"],
                                        row["phone"], row["home_town"], row["nationality"], row["language_support"], row["status"]))
    end
  end

  def imported_items
    @imported_items ||= load_imported_items
  end

  def save
    result = true
    imported_items

    @officerList.each do |item|
      officer = Officer.new
      officer.name = item.name
      officer.date_of_birth = item.date_of_birth.nil? ? nil : Date::strptime(item.date_of_birth, "%m/%d/%Y")
      officer.gender = item.gender
      officer.phone = item.phone.nil? ? "" : item.phone
      officer.home_town = item.home_town.nil? ? "" : item.home_town
      officer.nationality = item.nationality.nil? ? "" : item.nationality
      officer.language_support = item.language_support.nil? ? "" : item.language_support
      officer.status = item.status
      officer.online = false

      # Save attachment
      if !item.image.nil?
        attachments = item.image.split(',').map(&:strip)
        attachments_saved = []
        attachments.each do |item|
          attachment = save_image(item)
          if attachment != nil
            ActiveRecord::Base::transaction do
              _ok = create_attachment_file(attachment)
              raise ActiveRecord::Rollback, result = false unless _ok
              attachments_saved.push(attachment)
            end
            if result == false
              return false
            end
          end
        end
      end

      ActiveRecord::Base::transaction do
        _ok = officer.save
        raise ActiveRecord::Rollback, result = false unless _ok

        # Save officer_attachment
        if !item.image.nil?
          attachments_saved.each do |item|
            officer_attachment = OfficerAttachment.new
            officer_attachment.officer_id = officer.id
            officer_attachment.attachment_id = item.id
            ActiveRecord::Base::transaction do
              _ok = officer_attachment.save
              raise ActiveRecord::Rollback, result = false unless _ok
            end
            if result == false
              return false
            end
          end
        end
      end

      if result == false
        return false
      end
    end

    return true
  end

  def save_image(file_name)
    if file_name.nil?
      return nil
    end
    attachment = Attachment.new
    begin
      attachment.file = Pathname.new(Rails.root.join("db/import/images/#{file_name}")).open
    rescue Exception => e
      return nil
    end
    attachment.category = get_extension_file_upload(attachment.file)
    attachment.name = file_name
    attachment.file_hash = Digest::MD5.hexdigest(attachment.file.read)
    return attachment
  end
end

class OfficerData
  attr_accessor :name, :date_of_birth, :gender, :phone, :home_town, :nationality, :language_support, :online, :status, :image

  def initialize(name, date_of_birth, gender, phone, home_town, nationality, language_support, online, status, image)
    @name = name
    @date_of_birth = date_of_birth
    @gender = gender
    @phone = phone
    @home_town = home_town
    @nationality = nationality
    @language_support = language_support
    @online = online
    @status = status
    @image = image
  end
end