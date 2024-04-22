class IntroductionsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_introduction, only: %i[ show edit update destroy ]

  include AttachmentModule
  # GET /introductions or /introductions.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @introductions = Introduction.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /introductions/1 or /introductions/1.json
  def show
  end

  # GET /introductions/new
  def new
    @introduction = Introduction.new
  end

  # GET /introductions/1/edit
  def edit
  end

  # POST /introductions or /introductions.json
  def create
    result = true
    @introduction = Introduction.new(introduction_params)

    respond_to do |format|
      attachment = get_attachment_from_request(params[:introduction][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @introduction.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @introduction.errors, status: :unprocessable_entity }
        end
      end
      if @introduction.save
        format.html { redirect_to introduction_url(@introduction), notice: "Introduction was successfully created." }
        format.json { render :show, status: :created, location: @introduction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @introduction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /introductions/1 or /introductions/1.json
  def update
    result = true
    respond_to do |format|
      attachment = get_attachment_from_request(params[:introduction][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @introduction.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @introduction.errors, status: :unprocessable_entity }
        end
      end

      if @introduction.update(introduction_params_update)
        format.html { redirect_to introduction_url(@introduction), notice: "Introduction was successfully updated." }
        format.json { render :show, status: :ok, location: @introduction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @introduction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /introductions/1 or /introductions/1.json
  def destroy
    @introduction.destroy

    respond_to do |format|
      format.html { redirect_to introductions_url, notice: "Introduction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_introduction
      @introduction = Introduction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def introduction_params
      params.require(:introduction).permit(:title, :description, :intro_index, :attachment_id)
    end

    def introduction_params_update
      params.require(:introduction).permit(:title, :description, :intro_index)
    end
end
