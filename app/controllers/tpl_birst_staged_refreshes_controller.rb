class TplBirstStagedRefreshesController < ApplicationController
  before_action :set_tpl_birst_staged_refresh, only: [:show, :edit, :update, :destroy]

  # GET /tpl_birst_staged_refreshes
  # GET /tpl_birst_staged_refreshes.json
  def index
    @tpl_birst_staged_refreshes = TplBirstStagedRefresh.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tpl_birst_staged_refreshes }
    end
  end

  # GET /tpl_birst_staged_refreshes/1
  # GET /tpl_birst_staged_refreshes/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tpl_birst_staged_refresh }
    end
  end

  # GET /tpl_birst_staged_refreshes/new
  def new
    @tpl_birst_staged_refresh = TplBirstStagedRefresh.new
  end

  # GET /tpl_birst_staged_refreshes/1/edit
  def edit
  end

  # POST /tpl_birst_staged_refreshes
  # POST /tpl_birst_staged_refreshes.json
  def create
    @tpl_birst_staged_refresh = TplBirstStagedRefresh.new(tpl_birst_staged_refresh_params)

    respond_to do |format|
      if @tpl_birst_staged_refresh.save
        format.html { redirect_to @tpl_birst_staged_refresh, notice: 'Tpl birst staged refresh was successfully created.' }
        format.json { render json: @tpl_birst_staged_refresh, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @tpl_birst_staged_refresh.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tpl_birst_staged_refreshes/1
  # PATCH/PUT /tpl_birst_staged_refreshes/1.json
  def update
    respond_to do |format|
      if @tpl_birst_staged_refresh.update(tpl_birst_staged_refresh_params)
        format.html { redirect_to @tpl_birst_staged_refresh, notice: 'Tpl birst staged refresh was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tpl_birst_staged_refresh.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tpl_birst_staged_refreshes/1
  # DELETE /tpl_birst_staged_refreshes/1.json
  def destroy
    @tpl_birst_staged_refresh.destroy
    respond_to do |format|
      format.html { redirect_to tpl_birst_staged_refreshes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tpl_birst_staged_refresh
      @tpl_birst_staged_refresh = TplBirstStagedRefresh.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tpl_birst_staged_refresh_params
      params.require(:tpl_birst_staged_refresh).permit(:data_source_collection_id, :process_group_collection_id, :production_space_id, :staging_space_id)
    end
end
