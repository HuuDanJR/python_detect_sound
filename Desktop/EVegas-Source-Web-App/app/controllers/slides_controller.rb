class SlidesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_slide, only: %i[ show edit update destroy ]

  include AttachmentModule
  # GET /slides or /slides.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @slides = Slide.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /slides/1 or /slides/1.json
  def show
  end

  # GET /slides/new
  def new
    @slide = Slide.new
  end

  # GET /slides/1/edit
  def edit
  end

  # POST /slides or /slides.json
  def create
    result = true
    @slide = Slide.new(slide_params)

    respond_to do |format|
      attachment = get_attachment_from_request(params[:slide][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @slide.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @slide.errors, status: :unprocessable_entity }
        end
      end

      if @slide.save
        format.html { redirect_to slide_url(@slide), notice: "Slide was successfully created." }
        format.json { render :show, status: :created, location: @slide }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /slides/1 or /slides/1.json
  def update
    result = true
    respond_to do |format|
      attachment = get_attachment_from_request(params[:slide][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @slide.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @slide.errors, status: :unprocessable_entity }
        end
      end

      if @slide.update(slide_params_update)
        format.html { redirect_to slide_url(@slide), notice: "Slide was successfully updated." }
        format.json { render :show, status: :ok, location: @slide }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slides/1 or /slides/1.json
  def destroy
    @slide.destroy

    respond_to do |format|
      format.html { redirect_to slides_url, notice: "Slide was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slide
      @slide = Slide.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def slide_params
      params.require(:slide).permit(:name, :slide_index, :attachment_id, :description, :is_show)
    end

    # Only allow a list of trusted parameters through.
    def slide_params_update
      params.require(:slide).permit(:name, :slide_index, :description, :is_show)
    end
end
