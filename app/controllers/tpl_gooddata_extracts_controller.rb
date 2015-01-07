class TplGooddataExtractsController < ApplicationController
  before_action :set_tpl_gooddata_extract, only: [:show, :edit, :update, :destroy]

  # GET /tpl_gooddata_extracts
  # GET /tpl_gooddata_extracts.json
  def index
    @tpl_gooddata_extracts = TplGooddataExtract.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tpl_gooddata_extracts }
    end
  end

  # GET /tpl_gooddata_extracts/1
  # GET /tpl_gooddata_extracts/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tpl_gooddata_extract }
    end
  end

  # GET /tpl_gooddata_extracts/new
  def new
    @tpl_gooddata_extract = TplGooddataExtract.new
  end

  # GET /tpl_gooddata_extracts/1/edit
  def edit
  end

  # POST /tpl_gooddata_extracts
  # POST /tpl_gooddata_extracts.json
  def create
    @tpl_gooddata_extract = TplGooddataExtract.new(tpl_gooddata_extract_params)

    respond_to do |format|
      if @tpl_gooddata_extract.save
        format.html { redirect_to @tpl_gooddata_extract, notice: 'Tpl gooddata extract was successfully created.' }
        format.json { render json: @tpl_gooddata_extract, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @tpl_gooddata_extract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tpl_gooddata_extracts/1
  # PATCH/PUT /tpl_gooddata_extracts/1.json
  def update
    respond_to do |format|
      if @tpl_gooddata_extract.update(tpl_gooddata_extract_params)
        format.html { redirect_to @tpl_gooddata_extract, notice: 'Tpl gooddata extract was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tpl_gooddata_extract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tpl_gooddata_extracts/1
  # DELETE /tpl_gooddata_extracts/1.json
  def destroy
    @tpl_gooddata_extract.destroy
    respond_to do |format|
      format.html { redirect_to tpl_gooddata_extracts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tpl_gooddata_extract
      @tpl_gooddata_extract = TplGooddataExtract.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tpl_gooddata_extract_params
      params.require(:tpl_gooddata_extract).permit(:gooddata_project_id, :destination_credential_id, :destination_path)
    end
end
