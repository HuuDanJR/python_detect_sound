require 'digest'
require 'securerandom'
require "down"

class CustomerImport
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
      @customerList.push(CustomerData.new(row["number"], row["date_of_birth"]))
    end
  end

  def imported_items
    @imported_items ||= load_imported_items
  end

  def save
    result = true
    imported_items
    customers = []
    if(@customerList.length <= 0)
      return false
    end
    neon_api = Setting.where('setting_key = ?', 'NEON_API').first!.setting_value
    computer_name = Setting.where('setting_key = ?', 'NEON_COMPUTER_NAME').first!.setting_value
    @customerList.each do |item_data|
      item = get_customer_by_number(item_data.number, neon_api, computer_name)
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
        customer.date_of_birth = item_data.date_of_birth
        customers.push(customer)
      end
    end
    synchronize_customer(customers)

    return result
  end

end

class CustomerData
  attr_accessor :number, :date_of_birth

  def initialize(number, date_of_birth)
    @number = number
    @date_of_birth = date_of_birth
  end
end