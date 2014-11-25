class BirstExtractGroupsController < ApplicationController
  before_action :set_birst_extract_group, only: [:show, :edit, :update, :destroy]

  # GET /birst_extract_groups
  # GET /birst_extract_groups.json
  def index
    @birst_extract_groups = BirstExtractGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @birst_extract_groups }
    end
  end

  # GET /birst_extract_groups/1
  # GET /birst_extract_groups/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @birst_extract_group }
    end
  end

  # GET /birst_extract_groups/new
  def new
    @birst_extract_group = BirstExtractGroup.new
  end

  # GET /birst_extract_groups/1/edit
  def edit
  end

  # POST /birst_extract_groups
  # POST /birst_extract_groups.json
  def create
    @birst_extract_group = BirstExtractGroup.new(birst_extract_group_params)

    respond_to do |format|
      if @birst_extract_group.save
        format.html { redirect_to @birst_extract_group, notice: 'Birst extract group was successfully created.' }
        format.json { render json: @birst_extract_group, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @birst_extract_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /birst_extract_groups/1
  # PATCH/PUT /birst_extract_groups/1.json
  def update
    respond_to do |format|
      if @birst_extract_group.update(birst_extract_group_params)
        format.html { redirect_to @birst_extract_group, notice: 'Birst extract group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @birst_extract_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /birst_extract_groups/1
  # DELETE /birst_extract_groups/1.json
  def destroy
    @birst_extract_group.destroy
    respond_to do |format|
      format.html { redirect_to birst_extract_groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_birst_extract_group
      @birst_extract_group = BirstExtractGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def birst_extract_group_params
      params.require(:birst_extract_group).permit(:name, :description)
    end
end
