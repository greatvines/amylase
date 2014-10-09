class BirstProcessGroupsController < ApplicationController
  before_action :set_birst_process_group, only: [:show, :edit, :update, :destroy]

  # GET /birst_process_groups
  # GET /birst_process_groups.json
  def index
    @birst_process_groups = BirstProcessGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @birst_process_groups }
    end
  end

  # GET /birst_process_groups/1
  # GET /birst_process_groups/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @birst_process_group }
    end
  end

  # GET /birst_process_groups/new
  def new
    @birst_process_group = BirstProcessGroup.new
  end

  # GET /birst_process_groups/1/edit
  def edit
  end

  # POST /birst_process_groups
  # POST /birst_process_groups.json
  def create
    @birst_process_group = BirstProcessGroup.new(birst_process_group_params)

    respond_to do |format|
      if @birst_process_group.save
        flash[:success] = "Success! BirstProcessGroup created."
        format.html { redirect_to @birst_process_group }
        format.json { render json: @birst_process_group, status: :created }
      else
        flash[:danger] = "Error! BirstProcessGroup not created: #{@birst_process_group.errors.full_messages}"
        format.html { render action: 'new' }
        format.json { render json: @birst_process_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /birst_process_groups/1
  # PATCH/PUT /birst_process_groups/1.json
  def update
    respond_to do |format|
      if @birst_process_group.update(birst_process_group_params)
        flash[:success] = "Success! BirstProcessGroup updated."
        format.html { redirect_to @birst_process_group }
        format.json { head :no_content }
      else
        flash[:danger] = "Error! BirstProcessGroup not updated: #{@birst_process_group.errors.full_messages}"
        format.html { render action: 'edit' }
        format.json { render json: @birst_process_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /birst_process_groups/1
  # DELETE /birst_process_groups/1.json
  def destroy
    @birst_process_group.destroy
    respond_to do |format|
      flash[:success] = 'Success! BirstProcessGroup destroyed.'
      format.html { redirect_to birst_process_groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_birst_process_group
      @birst_process_group = BirstProcessGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def birst_process_group_params
      params.require(:birst_process_group).permit(:name, :description)
    end
end
