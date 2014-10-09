class DataSourceGroupsController < ApplicationController
  before_action :set_data_source_group, only: [:show, :edit, :update, :destroy]

  # GET /data_source_groups
  # GET /data_source_groups.json
  def index
    @data_source_groups = DataSourceGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data_source_groups }
    end
  end

  # GET /data_source_groups/1
  # GET /data_source_groups/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @data_source_group }
    end
  end

  # GET /data_source_groups/new
  def new
    @data_source_group = DataSourceGroup.new
  end

  # GET /data_source_groups/1/edit
  def edit
  end

  # POST /data_source_groups
  # POST /data_source_groups.json
  def create
    @data_source_group = DataSourceGroup.new(data_source_group_params)

    respond_to do |format|
      if @data_source_group.save
        flash[:success] = "Success! DataSourceGroup created."
        format.html { redirect_to @data_source_group }
        format.json { render json: @data_source_group, status: :created }
      else
        flash[:danger] = "Error! DataSourceGroup not created: #{@data_source_group.errors.full_messages}"
        format.html { render action: 'new' }
        format.json { render json: @data_source_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_source_groups/1
  # PATCH/PUT /data_source_groups/1.json
  def update
    respond_to do |format|
      if @data_source_group.update(data_source_group_params)
        flash[:success] = "Success! DataSourceGroup updated."
        format.html { redirect_to @data_source_group }
        format.json { head :no_content }
      else
        flash[:danger] = "Error! DataSourceGroup not updated: #{@data_source_group.errors.full_messages}"
        format.html { render action: 'edit' }
        format.json { render json: @data_source_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_source_groups/1
  # DELETE /data_source_groups/1.json
  def destroy
    @data_source_group.destroy
    respond_to do |format|
      flash[:success] = 'Success! DataSourceGroup destroyed.'
      format.html { redirect_to data_source_groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_source_group
      @data_source_group = DataSourceGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_source_group_params
      params.require(:data_source_group).permit(:name, data_source_ids: [])
    end
end
