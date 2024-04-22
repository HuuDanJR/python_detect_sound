class JackpotGameTypesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_jackpot_game_type, only: %i[ show edit update destroy ]

  include CommonModule

  # GET /jackpot_game_types or /jackpot_game_types.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @jackpot_game_types = JackpotGameType.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @jackpot_game_types = JackpotGameType.where("name LIKE ?", "%#{@search_query}%").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /jackpot_game_types/1 or /jackpot_game_types/1.json
  def show
  end

  # GET /jackpot_game_types/new
  def new
    @jackpot_game_type = JackpotGameType.new
  end

  # GET /jackpot_game_types/1/edit
  def edit
  end

  # POST /jackpot_game_types or /jackpot_game_types.json
  def create
    @jackpot_game_type = JackpotGameType.new(jackpot_game_type_params)

    respond_to do |format|
      if @jackpot_game_type.save
        format.html { redirect_to jackpot_game_type_url(@jackpot_game_type), notice: "Jackpot game type was successfully created." }
        format.json { render :show, status: :created, location: @jackpot_game_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @jackpot_game_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jackpot_game_types/1 or /jackpot_game_types/1.json
  def update
    respond_to do |format|
      if @jackpot_game_type.update(jackpot_game_type_params)
        format.html { redirect_to jackpot_game_type_url(@jackpot_game_type), notice: "Jackpot game type was successfully updated." }
        format.json { render :show, status: :ok, location: @jackpot_game_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jackpot_game_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jackpot_game_types/1 or /jackpot_game_types/1.json
  def destroy
    @jackpot_game_type.destroy

    respond_to do |format|
      format.html { redirect_to jackpot_game_types_url, notice: "Jackpot game type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jackpot_game_type
      @jackpot_game_type = JackpotGameType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jackpot_game_type_params
      params.require(:jackpot_game_type).permit(:name)
    end
end
