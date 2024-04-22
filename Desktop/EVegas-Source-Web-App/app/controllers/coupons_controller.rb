class CouponsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_coupon, only: %i[ show edit update destroy]

  # GET /coupons or /coupons.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]

    @coupons = Coupon.joins(:customer)
                    .select("coupons.*, customers.forename as customer_forename, customers.surname as customer_surname, customers.number as customer_number, 'status_coupon', 'status_type', 'benefit_name', 'benefit_note'")

    if !is_blank(@search_query)
      @coupons = @coupons.where("coupons.name LIKE ? OR customers.forename LIKE ? OR customers.middle_name LIKE ? OR customers.surname LIKE ? OR customers.number LIKE ?", 
                          "%#{@search_query.strip}%", "%#{@search_query.strip}%","%#{@search_query.strip}%", "%#{@search_query.strip}%", "%#{@search_query.strip}%").order('number asc, time_start desc')
    else
      @coupons = @coupons.order('time_start desc, id desc')
    end

    @date_from = params[:date_from]
    @date_to = params[:date_to]
    if !is_blank(@date_from) && !is_blank(@date_to)
      date_from = DateTime.parse(@date_from)
      date_to = DateTime.parse(@date_to).change({ hour: 23, min: 59, sec: 59 })
      @coupons = @coupons.where("time_start BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    @coupon_template_id = params[:coupon_template_id]
    @coupon_templates = CouponTemplate.order("name asc")
    if !is_blank(@coupon_template_id)
      @coupons = @coupons.where("coupon_template_id = ?", @coupon_template_id.to_i)
    end

    @coupons = @coupons.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    if @coupons.length > 0
      @coupons.each do |item|
        item.status_coupon = check_status_coupon(item, 0)
        item.status_type = item.status_coupon == "Expired" || item.status_coupon == "Used All" ? 0 : 1
      end
    end
  end

  # GET /coupons/1 or /coupons/1.json
  def show
    @coupon = Coupon
                .joins(:customer)
                .select("
                  coupons.*,
                  customers.forename as customer_forename,
                  customers.surname as customer_surname,
                  customers.number as customer_number
                ")
                .find(params[:id])

    @benefits = Coupon
                  .left_outer_joins(:benefits)
                  .select("benefits.name,benefits.attachment_id,coupon_benefits.total_usage,coupon_benefits.count_usage, coupon_benefits.note")
                  .where('coupons.id = ? AND coupon_benefits.status > 0', @coupon.id)
  end

  # GET /coupons/new
  def new
    @coupon = Coupon.new
    @coupon.time_start = DateTime.now
    @benefits = Benefit.select("id, name, attachment_id").where("status > 0")
    @benefit_config = CouponTemplate.all.order("name asc")
    @coupon_benefit_ids = []
  end

  # GET /coupons/1/edit
  def edit
    @benefits = Benefit.select("id, name, attachment_id").where("status > 0")
    @coupon_benefits = CouponBenefit.select("id, benefit_id, total_usage, count_usage, note").where("coupon_id = ? AND status > 0", @coupon.id)
    @coupon_benefit_ids = @coupon_benefits.pluck(:benefit_id)
    @benefit_config = CouponTemplate.all.order("name asc")
    @is_extend = params[:is_extend]
    if is_blank(@is_extend)
      @is_extend = 0
    end
  end

  # POST /coupons or /coupons.json
  def create
    @coupon_benefit_ids = []
    @benefits = Benefit.select("id, name, attachment_id").where("status > 0")
    @coupon = Coupon.new(coupon_params)
    @coupon.expired = @coupon.expired.end_of_day
    @benefit_config = CouponTemplate.all.order("name asc")
    benefit_ids = benefits_coupon_params[:benefit_ids]
    total_usages = benefits_coupon_params[:total_usages]

    respond_to do |format|
      Coupon.transaction do 
        @coupon.save!
        benefit_ids.each_with_index do |benefit_id, index|
          coupon = CouponBenefit.new(
            coupon_id: @coupon.id,
            benefit_id: benefit_id.to_i,
            total_usage: total_usages[index].to_i,
          )
          coupon.save!
        end
      rescue Exception => e 
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
      format.html { redirect_to coupon_url(@coupon), notice: "Coupon was successfully created." }
      format.json { render :show, status: :created, location: @coupon }
    end
  end

  # PATCH/PUT /coupons/1 or /coupons/1.json
  def update
    @benefits = Benefit.select("id, name, attachment_id").where("status > 0")
    @coupon_benefits = CouponBenefit.select("benefit_id, total_usage, count_usage, note").where("coupon_id = ? AND status > 0", @coupon.id)
    
    @benefit_config = CouponTemplate.all.order("name asc")
    
    @coupon_benefit_ids = @coupon_benefits.pluck(:benefit_id)
    @is_extend = params[:is_extend]
    if is_blank(@is_extend)
      @is_extend = 0
    end
    respond_to do |format|
      @coupon.update(coupon_params)
      if @is_extend.to_i == 0
        submit_benefit_ids = benefits_coupon_params[:benefit_ids] == nil ? [] : benefits_coupon_params[:benefit_ids].map {|id| id.to_i}
        total_usages = benefits_coupon_params[:total_usages]
        count_usages = benefits_coupon_params[:count_usages]
        Coupon.transaction do
          if submit_benefit_ids.length > 0
            exist_benefit_ids = CouponBenefit.select("benefit_id").where("coupon_id = ? AND status > 0", @coupon.id).pluck(:benefit_id)

            destroy_benefit_ids = exist_benefit_ids - submit_benefit_ids
            new_benefit_ids = submit_benefit_ids - exist_benefit_ids
            update_benefit_ids = submit_benefit_ids - new_benefit_ids

            if !is_blank(destroy_benefit_ids)
              CouponBenefit.where("status > 0 AND coupon_id = ? AND benefit_id IN (?)", @coupon.id, destroy_benefit_ids).destroy_all();
            end

            new_coupon_benefit_dtos = new_benefit_ids.map do |new_benefit_id|
              {
                coupon_id: @coupon.id,
                benefit_id: new_benefit_id,
                count_usage: count_usages[submit_benefit_ids.find_index(new_benefit_id)],
                total_usage: total_usages[submit_benefit_ids.find_index(new_benefit_id)],
                status: 1,
                created_at: Time.now,
                updated_at: Time.now
              }
            end
            if !is_blank(new_coupon_benefit_dtos)
              CouponBenefit.insert_all(new_coupon_benefit_dtos)
            end
            update_benefit_ids.each do |benefit_id|
              CouponBenefit.where(coupon_id: @coupon.id, benefit_id: benefit_id, status: 1).update({
                count_usage: count_usages[submit_benefit_ids.find_index(benefit_id)],
                total_usage: total_usages[submit_benefit_ids.find_index(benefit_id)]
              })
            end
          end
        rescue Exception => e 
          format.html { render :edit, :is_extend=>@is_extend,  status: :unprocessable_entity }
          format.json { render json: @coupon.errors, status: :unprocessable_entity }
          return
        end
      end
      format.html { redirect_to "/coupons/#{@coupon.id}", notice: "Coupon was successfully updated." }
      format.json { render :show, status: :created, location: @coupon }
    end
  end

  # DELETE /coupons/1 or /coupons/1.json
  def destroy
    coupon_id_tmp = @coupon.id.to_i
    respond_to do |format|
      if @coupon.destroy 
        coupon_benefits = CouponBenefit.where("coupon_id = ?", coupon_id_tmp)
        if coupon_benefits.length > 0
          coupon_benefits.destroy_all
        end
        format.html { redirect_to coupons_url, notice: "Coupon was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to coupons_url, alert: "Coupon was failed destroyed." }
        format.json { head :no_content }
      end
    end
  end

  def used_benefit
    data = JSON.parse(request.body.read)
    stamp = data['stamp'].to_i
    note_cp = data['note_coupon'].strip
    coupon_benefit = CouponBenefit.find(params[:id])
    coupon_tmp = Coupon.select("*,'benefit_name','benefit_note'").where(id: coupon_benefit.coupon_id).first
    if !coupon_benefit.nil?
      if stamp == 1
        if coupon_benefit.count_usage < coupon_benefit.total_usage
          coupon_benefit.count_usage = coupon_benefit.count_usage + 1
        end
      end
      if coupon_benefit.save
        if coupon_benefit.count_usage == coupon_benefit.total_usage
          if coupon_tmp != nil
            coupon_tmp.modified_date = Time.zone.now
            coupon_status = check_status_coupon(coupon_tmp, 0)
            if coupon_status == "Expired" || coupon_status == "Used All"
              coupon_tmp.used = 1
              coupon_tmp.save
            else
              coupon_tmp.used = 0
              coupon_tmp.save
            end
          end
        end
        coupon_benefit_time = CouponBenefitTime.new
        coupon_benefit_time.coupon_id = coupon_benefit.coupon_id
        coupon_benefit_time.benefit_id = coupon_benefit.benefit_id
        coupon_benefit_time.time_used = Time.zone.now
        coupon_benefit_time.save
      end
      if note_cp != ""
        coupon_tmp.note = note_cp
        coupon_tmp.save
      end
    end
    render json: coupon_benefit
    return
  end

  def undo_benefit
    data = JSON.parse(request.body.read)
    stamp = data['stamp'].to_i
    note_cp = data['note_coupon'].strip
    coupon_benefit = CouponBenefit.find(params[:id])
    coupon_tmp = Coupon.select("*,'benefit_name','benefit_note'").where(id: coupon_benefit.coupon_id).first
    if !coupon_benefit.nil?
      if stamp == 0
        if coupon_benefit.count_usage != 0
          coupon_benefit.count_usage = coupon_benefit.count_usage - 1
          if coupon_tmp != nil
            coupon_tmp.modified_date = Time.zone.now
            coupon_tmp.used = 0
            coupon_tmp.save
          end
        end
      end
      if coupon_benefit.save
        if coupon_benefit.count_usage == coupon_benefit.total_usage
          if coupon_tmp != nil
            coupon_tmp.modified_date = Time.zone.now
            coupon_status = check_status_coupon(coupon_tmp, 0)
            if coupon_status == "Expired" || coupon_status == "Used All"
              coupon_tmp.used = 1
              coupon_tmp.save
            else
              coupon_tmp.used = 0
              coupon_tmp.save
            end
          end
        end
        coupon_benefit_time = CouponBenefitTime.where('benefit_id = ? AND coupon_id = ?', coupon_benefit.benefit_id, coupon_benefit.coupon_id).last
        if coupon_benefit_time != nil
          coupon_benefit_time.destroy
        end
      end
      if note_cp != ""
        coupon_tmp.note = note_cp
        coupon_tmp.save
      end
    end
    render json: coupon_benefit
    return
  end

  def update_note_benefit
    data = JSON.parse(request.body.read)
    note = data['note'].strip
    note_cp = data['note_coupon'].strip
    coupon_benefit = CouponBenefit.find(params[:id])
    if !coupon_benefit.nil?
      coupon_benefit.note = note
      coupon_benefit.save
      if note_cp != ""
        coupon_note = Coupon.where('id = ?', coupon_benefit.coupon_id.to_i).first
        coupon_note.note = note_cp
        coupon_note.save
      end
    end
    
    render json: coupon_benefit
    return
  end

  # EXPORT /officers/export
  def export
    search_query = params[:search]
    date_from = params[:date_from]
    date_to = params[:date_to]
    coupons = Coupon.joins(:customer)
                    .select("coupons.*, customers.forename as customer_forename, customers.surname as customer_surname, customers.number as customer_number, issued, 'benefit_name', 'benefit_note'")

    if !is_blank(search_query)
      coupons = coupons.where("coupons.name LIKE ? OR customers.number LIKE ?", "%#{search_query.strip}%", "%#{search_query.strip}%")
    end

    if !is_blank(date_from) && !is_blank(date_to)
      date_from = DateTime.parse(date_from)
      date_to = DateTime.parse(date_to).change({ hour: 23, min: 59, sec: 59 })
      coupons = coupons.where("time_start BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    coupon_template_id = params[:coupon_template_id]
    coupon_templates = CouponTemplate.order("name asc")
    if !is_blank(coupon_template_id)
      coupons = coupons.where("coupons.coupon_template_id = ?", coupon_template_id.to_i)
    end


    coupons = coupons.order('time_start desc')
    send_file_list(coupons, coupon_template_id)
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coupon
      @coupon = Coupon.find(params[:id])
      customer = Customer.find_by(id: @coupon[:customer_id])
      @customer_number = customer.forename.to_s + " " + customer.middle_name.to_s + " " + customer.surname.to_s + " - " + customer.number.to_s
    end

    # Only allow a list of trusted parameters through.
    def coupon_params
      params.require(:coupon).permit(:customer_id, :name, :title, :description, :mb, :no, :issued, :expired, :time_start, :description_ja, :description_kr, :description_cn, :serial_no, :coupon_template_id, :note, :name_ja, :name_kr, :name_cn)
    end
    def benefits_coupon_params
      params.require(:coupon).permit(:benefit_ids => [], :total_usages => [], :count_usages => [], :note => [])
    end

    def send_file_list(officers, coupon_template_id)
      book = Axlsx::Package.new
      workbook = book.workbook
      sheet = workbook.add_worksheet name: "Report"
  
      styles = book.workbook.styles
      header_style = styles.add_style bg_color: "ffff00",
                                      fg_color: "00",
                                      b: true,
                                      alignment: {horizontal: :center, :vertical => :center, :wrap_text => true},
                                      border: {style: :thin, color: 'F000000', :edges => [:left, :right, :top, :bottom]}
      border_style = styles.add_style :border => {:style => :thin, :color => 'F000000', :edges => [:left, :right, :top, :bottom]}
      wrap_text_style = styles.add_style alignment: {:horizontal => :left, :vertical => :center, :wrap_text => true}
      other_style = styles.add_style alignment: {:horizontal => :left, :vertical => :center, :wrap_text => true}
      
      benefits = Benefit.select('name, id').where("benefits.status > 0")

      if !is_blank(coupon_template_id)
        coupon_template = CouponTemplate.where(id: coupon_template_id).first
        if coupon_template !=  nil
          if coupon_template.benefit_ids.present?
            coupon_template_ids = coupon_template.benefit_ids.split(',')
            benefits = Benefit.select('name, id').where("status > 0 AND id in (?)", coupon_template_ids)
          end
        end

      end

      base_headers = ["No.",
                     "Number/ Email",
                     "Name",
                     "Coupon Name",
                     "Serial No",
                     "Issue Date",
                     "Expire Date",
                     "Benefit Modified Date",
                     "Status",
                     "Issued By",
                     "Note",
                     "Benefit Note"]
      
      if benefits.length > 0
        benefits.each do |item|
          base_headers << item.name.to_s
        end
      end
      sheet.add_row base_headers, style: header_style, height: 60
      stt = 0
      officers.each do |item|
        stt = stt + 1
        time_start = item.time_start != nil ? item.time_start.strftime("%d-%m-%Y") : ""
        time_expired = item.expired != nil ? item.expired.strftime("%d-%m-%Y") : ""
        time_benefit = item.modified_date != nil ? item.modified_date.strftime("%d-%m-%Y") : ""
        status_cp = check_status_coupon(item, 1)
        customer_name = item.customer_surname + " " + item.customer_forename
        formatter = ExcelFormatter.new(item.note)
        plain_text = formatter.to_plain_text
        formatter_note = ExcelFormatter.new(item.benefit_note)
        text_cp_note = formatter_note.to_plain_text
        row_data = [stt,
                       item.customer_number,
                       customer_name,
                       item.name,
                       item.serial_no,
                       time_start,
                       time_expired,
                       time_benefit,
                       status_cp,
                       item.issued,
                       plain_text,
                       text_cp_note
                       ]
        if benefits.length > 0
          benefits.each do |benefit_item|
            if !item.benefit_name.present?
              row_data << ""
            else
              coupon_benefit_time_data = CouponBenefitTime.where('coupon_id = ? AND benefit_id = ?', item.id, benefit_item.id).last
              if coupon_benefit_time_data != nil
                row_data << coupon_benefit_time_data.time_used.strftime("%d-%m-%Y")
              else
                row_data << ""
              end
            end
          end
        end
        sheet.add_row row_data, types: [:string,:string,:string,:string,:string,:string,:string,:string,:string,:string,:string,:string], 
                                  style: [other_style, wrap_text_style, wrap_text_style, wrap_text_style, other_style, wrap_text_style, wrap_text_style, wrap_text_style, wrap_text_style, other_style, wrap_text_style, wrap_text_style, wrap_text_style]
      end
      
      sheet.column_info[0].width = 5
      sheet.column_info[1].width = 10
      sheet.column_info[2].width = 10
      sheet.column_info[3].width = 20
      sheet.column_info[4].width = 10
      sheet.column_info[5].width = 12
      sheet.column_info[6].width = 12
      sheet.column_info[7].width = 12
      sheet.column_info[8].width = 10
      sheet.column_info[9].width = 10
      sheet.column_info[10].width = 35
      sheet.column_info[11].width = 35
      if benefits.length > 0
        index_col = 11
        benefits.each do |item|
          index_col = index_col + 1
          sheet.column_info[index_col].width = 20
        end
      end
      folder_name = "coupons"
      filename = "coupons_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end

    def check_status_coupon(coupon, is_report)
      if coupon.expired < Time.zone.now.beginning_of_day && is_report == 0
        return "Expired"
      end
      benefits = Coupon
                  .left_outer_joins(:benefits)
                  .select("benefits.name,benefits.attachment_id,coupon_benefits.total_usage,coupon_benefits.count_usage, coupon_benefits.note")
                  .where('coupons.id = ? AND coupon_benefits.status > 0', coupon.id)
      coupon.benefit_name = ""
      coupon.benefit_note = ""
      count = 0
      if benefits.length > 0
        benefits.each do |item|
          if item.note != ""
            if coupon.benefit_note == ""
              coupon.benefit_note = item.note
            else
              coupon.benefit_note = coupon.benefit_note + "<br>" + item.note
            end
          end

          if item.count_usage > 0
            if count == 0
              coupon.benefit_name = item.name
            else
              coupon.benefit_name = coupon.benefit_name + ", " + item.name
            end
          end

          if item.total_usage == item.count_usage
            count = count + 1
          end
        end
      end
      # puts coupon.benefit_note

      if coupon.expired < Time.zone.now.beginning_of_day && is_report == 1
        return "Expired"
      end

      if count == benefits.length
        return "Used All"
      else
        return "Used " + count.to_s + "/" + benefits.length.to_s
      end
    end
end
