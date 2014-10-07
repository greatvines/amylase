class DataSourcesController < ApplicationController
  before_action :set_data_source, only: [:show, :edit, :update, :destroy]

  # GET /data_sources
  # GET /data_sources.json
  def index
    @data_sources = DataSource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data_sources }
    end
  end

  # GET /data_sources/1
  # GET /data_sources/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @data_source }
    end
  end

  # GET /data_sources/new
  def new
    @data_source = DataSource.new
  end

  # GET /data_sources/1/edit
  def edit
  end

  # POST /data_sources
  # POST /data_sources.json
  def create
    @data_source = DataSource.new(data_source_params)

    respond_to do |format|
      if @data_source.save
        format.html { redirect_to @data_source, notice: 'Data source was successfully created.' }
        format.json { render json: @data_source, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @data_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_sources/1
  # PATCH/PUT /data_sources/1.json
  def update
    respond_to do |format|
      if @data_source.update(data_source_params)
        format.html { redirect_to @data_source, notice: 'Data source was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @data_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_sources/1
  # DELETE /data_sources/1.json
  def destroy
    @data_source.destroy
    respond_to do |format|
      format.html { redirect_to data_sources_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_source
      @data_source = DataSource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_source_params
      params.require(:data_source).permit(:name, :birst_filename, :data_source_type, :redshift_sql, :s3_path)
    end
end
