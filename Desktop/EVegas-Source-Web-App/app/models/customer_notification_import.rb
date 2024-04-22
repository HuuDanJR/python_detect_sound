require 'digest'
require 'securerandom'
require "down"

class CustomerNotificationImport
  include ActiveModel::Model
  require 'roo'

  attr_accessor :file


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

    @customerNotification = []
    header = spreadsheet.sheet(0).row(1)
    (2..spreadsheet.sheet(0).last_row).map do |i|
      row = Hash[[header, spreadsheet.sheet(0).row(i)].transpose]
      @customerNotification.push(StaffData.new(row["number"]))
    end
  end

  def imported_items
    @imported_items ||= load_imported_items
  end

  def save
    imported_items
    return @customerNotification
  end

end

class StaffData
  attr_accessor :number

  def initialize(number)
    @number = number
  end
end