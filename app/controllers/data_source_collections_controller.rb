class DataSourceCollectionsController < ApplicationController
  before_action :set_data_source_collection, only: [:show, :edit, :update, :destroy]

  # GET /data_source_collections
  # GET /data_source_collections.json
  def index
    @data_source_collections = DataSourceCollection.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data_source_collections }
    end
  end

  # GET /data_source_collections/1
  # GET /data_source_collections/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @data_source_collection }
    end
  end

  # GET /data_source_collections/new
  def new
    @data_source_collection = DataSourceCollection.new
  end

  # GET /data_source_collections/1/edit
  def edit
  end

  # POST /data_source_collections
  # POST /data_source_collections.json
  def create
    @data_source_collection = DataSourceCollection.new(data_source_collection_params)

    respond_to do |format|
      if @data_source_collection.save
        flash[:success] = "Success! DataSourceCollection created."
        format.html { redirect_to @data_source_collection }
        format.json { render json: @data_source_collection, status: :created }
      else
        flash[:danger] = "Error! DataSourceCollection not created: #{@data_source_collection.errors.full_messages}"
        format.html { render action: 'new' }
        format.json { render json: @data_source_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_source_collections/1
  # PATCH/PUT /data_source_collections/1.json
  def update
    respond_to do |format|
      if @data_source_collection.update(data_source_collection_params)
        flash[:success] = "Success! DataSourceCollection updated."
        format.html { redirect_to @data_source_collection }
        format.json { head :no_content }
      else
        flash[:danger] = "Error! DataSourceCollection not updated: #{@data_source_collection.errors.full_messages}"
        format.html { render action: 'edit' }
        format.json { render json: @data_source_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_source_collections/1
  # DELETE /data_source_collections/1.json
  def destroy
    @data_source_collection.destroy
    respond_to do |format|
      flash[:success] = 'Success! DataSourceCollection destroyed.'
      format.html { redirect_to data_source_collections_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_source_collection
      @data_source_collection = DataSourceCollection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_source_collection_params
      params.require(:data_source_collection).permit(:name, data_source_ids: [])
    end
end
