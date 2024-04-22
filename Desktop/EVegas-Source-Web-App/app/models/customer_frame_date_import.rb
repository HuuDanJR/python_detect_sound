require 'digest'
require 'securerandom'
require "down"

class CustomerFrameDateImport
  include ActiveModel::Model
  require 'roo'

  attr_accessor :file

  include AttachmentModule
  include CustomerModule

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

    @customerList = []
    header = spreadsheet.sheet(0).row(1)
    (2..spreadsheet.sheet(0).last_row).map do |i|
      row = Hash[[header, spreadsheet.sheet(0).row(i)].transpose]
      if (safe_date(row["END"]) && safe_date(row["START"]))
        @customerList.push(CustomerFrameDateData.new(row["#-MB"], row["START"], row["END"]))
      end
    end
  end

  def safe_date(string_date)
    date_tmp = DateTime.parse(string_date)
    return true
  rescue TypeError, ::DateTime::Error
    return false
  end

  def imported_items
    @imported_items ||= load_imported_items
  end

  def save
    result = true
    imported_items
    customers = []
    puts @customerList.to_s
    if(@customerList.length <= 0)
      return false
    end
    neon_api = Setting.where('setting_key = ?', 'NEON_API').first!.setting_value
    computer_name = Setting.where('setting_key = ?', 'NEON_COMPUTER_NAME').first!.setting_value
    @customerList.each do |item_data|
      customerNew = Customer.find_by(number: item_data.number.to_i)
      if customerNew.nil? == false
        customerNew.frame_start_date = item_data.frame_start_date
        customerNew.frame_end_date = item_data.frame_end_date
        customerNew.last_update_frame_point = DateTime.now
        customers.push(customerNew)
      else
        item = get_customer_by_number(item_data.number.to_i, neon_api, computer_name)
        if !item.nil?
          customer = Customer.new
          customer.age = item[:age]
          customer.card_number = item[:card_number]
          customer.cashless_balance = item[:cashless_balance]
          customer.colour = item[:colour]
          customer.colour_html = item[:colour_html]
          customer.comp_balance = item[:comp_balance]
          customer.comp_status_colour = item[:comp_status_colour]
          customer.comp_status_colour_html = item[:comp_status_colour_html]
          customer.forename = item[:forename]
          customer.freeplay_balance = item[:freeplay_balance]
          customer.gender = item[:gender]
          customer.has_online_account = item[:has_online_account]
          customer.hide_comp_balance = item[:hide_comp_balance]
          customer.is_guest = item[:is_guest]
          customer.loyalty_balance = item[:loyalty_balance]
          customer.loyalty_points_available = item[:loyalty_points_available]
          customer.membership_type_name = item[:membership_type_name]
          customer.middle_name = item[:middle_name]
          customer.number = item[:number]
          customer.player_tier_name = item[:player_tier_name]
          customer.player_tier_short_code = item[:player_tier_short_code]
          customer.premium_player = item[:premium_player]
          customer.surname = item[:surname]
          customer.title = item[:title]
          customer.valid_membership = item[:valid_membership]
          customer.frame_start_date = item_data.frame_start_date
          customer.frame_end_date = item_data.frame_end_date
          customer.last_update_frame_point = DateTime.now
          customers.push(customer)
        end
      end
    end
    synchronize_customer(customers)

    return result
  end

end

class CustomerFrameDateData
  attr_accessor :number, :frame_start_date, :frame_end_date

  def initialize(number, frame_start_date, frame_end_date)
    @number = number
    @frame_start_date = DateTime.parse(frame_start_date)
    @frame_end_date = DateTime.parse(frame_end_date)
  end
end