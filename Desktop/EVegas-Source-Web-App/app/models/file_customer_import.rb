
class FileCustomerImport
    attr_accessor :number_cfg, :title_cfg , :name_cfg, :amount_cfg, :amount_cfg_2, :date_month_year_cfg, :time_cfg, :host_phone_cfg
  
    def initialize(number_cfg, title_cfg , name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
      @number_cfg = number_cfg
      @title_cfg = title_cfg
      @name_cfg = name_cfg
      @amount_cfg = amount_cfg
      @amount_cfg_2 = amount_cfg_2
      @date_month_year_cfg = date_month_year_cfg
      @time_cfg = time_cfg
      @host_phone_cfg = host_phone_cfg
    end
end