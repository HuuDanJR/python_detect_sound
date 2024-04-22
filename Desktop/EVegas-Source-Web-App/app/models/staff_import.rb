require 'digest'
require 'securerandom'
require "down"

class StaffImport
  include ActiveModel::Model
  require 'roo'

  attr_accessor :file

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

    @staffList = []
    header = spreadsheet.sheet(0).row(1)
    (2..spreadsheet.sheet(0).last_row).map do |i|
      row = Hash[[header, spreadsheet.sheet(0).row(i)].transpose]
      @staffList.push(StaffData.new(row["code"], row["name"], row["nick_name"], row["position"], row["gender"]))
    end
  end

  def imported_items
    @imported_items ||= load_imported_items
  end

  def save
    result = true
    imported_items
    customers = []
    if(@staffList.length <= 0)
      return false
    end
    @staffList.each do |item|
        staff = Staff.new
        staff.code  = item.code
        staff.name  = item.name
        staff.nick_name  = item.nick_name
        staff.position  = item.position
        staff.gender  = item.gender == "M" ? 1 : 0
        staff.save!
    end
    return result
  end

end

class StaffData
  attr_accessor :code, :name, :nick_name, :position, :gender

  def initialize(code, name, nick_name, position, gender)
    @code = code
    @name = name
    @nick_name = nick_name
    @position = position
    @gender = gender
  end
end