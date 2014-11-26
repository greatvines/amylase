class BirstExtractGroupCollectionsController < ApplicationController
  before_action :set_birst_extract_group_collection, only: [:show, :edit, :update, :destroy]

  # GET /birst_extract_group_collections
  # GET /birst_extract_group_collections.json
  def index
    @birst_extract_group_collections = BirstExtractGroupCollection.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @birst_extract_group_collections }
    end
  end

  # GET /birst_extract_group_collections/1
  # GET /birst_extract_group_collections/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @birst_extract_group_collection }
    end
  end

  # GET /birst_extract_group_collections/new
  def new
    @birst_extract_group_collection = BirstExtractGroupCollection.new
  end

  # GET /birst_extract_group_collections/1/edit
  def edit
  end

  # POST /birst_extract_group_collections
  # POST /birst_extract_group_collections.json
  def create
    @birst_extract_group_collection = BirstExtractGroupCollection.new(birst_extract_group_collection_params)

    respond_to do |format|
      if @birst_extract_group_collection.save
        format.html { redirect_to @birst_extract_group_collection, notice: 'Birst extract group collection was successfully created.' }
        format.json { render json: @birst_extract_group_collection, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @birst_extract_group_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /birst_extract_group_collections/1
  # PATCH/PUT /birst_extract_group_collections/1.json
  def update
    respond_to do |format|
      if @birst_extract_group_collection.update(birst_extract_group_collection_params)
        format.html { redirect_to @birst_extract_group_collection, notice: 'Birst extract group collection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @birst_extract_group_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /birst_extract_group_collections/1
  # DELETE /birst_extract_group_collections/1.json
  def destroy
    @birst_extract_group_collection.destroy
    respond_to do |format|
      format.html { redirect_to birst_extract_group_collections_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_birst_extract_group_collection
      @birst_extract_group_collection = BirstExtractGroupCollection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def birst_extract_group_collection_params
      params.require(:birst_extract_group_collection).permit(:name, :description)
    end
end
