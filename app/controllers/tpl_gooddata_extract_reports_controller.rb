class TplGooddataExtractReportsController < ApplicationController
  before_action :set_tpl_gooddata_extract_report, only: [:show, :edit, :update, :destroy]

  # GET /tpl_gooddata_extract_reports
  # GET /tpl_gooddata_extract_reports.json
  def index
    @tpl_gooddata_extract_reports = TplGooddataExtractReport.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tpl_gooddata_extract_reports }
    end
  end

  # GET /tpl_gooddata_extract_reports/1
  # GET /tpl_gooddata_extract_reports/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tpl_gooddata_extract_report }
    end
  end

  # GET /tpl_gooddata_extract_reports/new
  def new
    @tpl_gooddata_extract_report = TplGooddataExtractReport.new
  end

  # GET /tpl_gooddata_extract_reports/1/edit
  def edit
  end

  # POST /tpl_gooddata_extract_reports
  # POST /tpl_gooddata_extract_reports.json
  def create
    @tpl_gooddata_extract_report = TplGooddataExtractReport.new(tpl_gooddata_extract_report_params)

    respond_to do |format|
      if @tpl_gooddata_extract_report.save
        format.html { redirect_to @tpl_gooddata_extract_report, notice: 'Tpl gooddata extract report was successfully created.' }
        format.json { render json: @tpl_gooddata_extract_report, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @tpl_gooddata_extract_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tpl_gooddata_extract_reports/1
  # PATCH/PUT /tpl_gooddata_extract_reports/1.json
  def update
    respond_to do |format|
      if @tpl_gooddata_extract_report.update(tpl_gooddata_extract_report_params)
        format.html { redirect_to @tpl_gooddata_extract_report, notice: 'Tpl gooddata extract report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tpl_gooddata_extract_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tpl_gooddata_extract_reports/1
  # DELETE /tpl_gooddata_extract_reports/1.json
  def destroy
    @tpl_gooddata_extract_report.destroy
    respond_to do |format|
      format.html { redirect_to tpl_gooddata_extract_reports_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tpl_gooddata_extract_report
      @tpl_gooddata_extract_report = TplGooddataExtractReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tpl_gooddata_extract_report_params
      params.require(:tpl_gooddata_extract_report).permit(:name, :tpl_gooddata_extract_id, :report_oid, :destination_file_name)
    end
end
