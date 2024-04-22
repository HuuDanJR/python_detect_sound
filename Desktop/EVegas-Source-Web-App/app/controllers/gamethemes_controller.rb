class GamethemesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_gametheme, only: %i[ show edit update destroy ]
  
  include CommonModule
  include AttachmentModule
  # GET /gamethemes or /gamethemes.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @gamethemes = Gametheme.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @gamethemes = Gametheme.where("name LIKE ?", "%#{@search_query}%").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /gamethemes/1 or /gamethemes/1.json
  def show
  end

  # GET /gamethemes/new
  def new
    @gametheme = Gametheme.new
  end

  # GET /gamethemes/1/edit
  def edit
  end

  # POST /gamethemes or /gamethemes.json
  def create
    result = true
    @gametheme = Gametheme.new(gametheme_params)

    respond_to do |format|
      attachment = get_attachment_from_request(params[:gametheme][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @gametheme.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :new }
          format.json { render json: @gametheme.errors, status: :unprocessable_entity }
        end
      end

      if @gametheme.save
        format.html { redirect_to @gametheme, notice: "Gametheme was successfully created." }
        format.json { render :show, status: :created, location: @gametheme }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gametheme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gamethemes/1 or /gamethemes/1.json
  def update
    result = true
    respond_to do |format|
      attachment = get_attachment_from_request(params[:gametheme][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok != 0
            @gametheme.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @gametheme.errors, status: :unprocessable_entity }
        end
      end

      if @gametheme.update(gametheme_update_params)
        format.html { redirect_to @gametheme, notice: "Gametheme was successfully updated." }
        format.json { render :show, status: :ok, location: @gametheme }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gametheme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gamethemes/1 or /gamethemes/1.json
  def destroy
    @gametheme.destroy

    respond_to do |format|
      format.html { redirect_to gamethemes_url, notice: "Gametheme was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gametheme
      @gametheme = Gametheme.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gametheme_params
      params.require(:gametheme).permit(:game_type_id, :name, :attachment_id)
    end

    # Only allow a list of trusted parameters through.
    def gametheme_update_params
      params.require(:gametheme).permit(:game_type_id, :name)
    end
end
