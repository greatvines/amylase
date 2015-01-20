class GooddataProjectsController < ApplicationController
  before_action :set_gooddata_project, only: [:show, :edit, :update, :destroy]

  # GET /gooddata_projects
  # GET /gooddata_projects.json
  def index
    @gooddata_projects = GooddataProject.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gooddata_projects }
    end
  end

  # GET /gooddata_projects/1
  # GET /gooddata_projects/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gooddata_project }
    end
  end

  # GET /gooddata_projects/new
  def new
    @gooddata_project = GooddataProject.new
  end

  # GET /gooddata_projects/1/edit
  def edit
  end

  # POST /gooddata_projects
  # POST /gooddata_projects.json
  def create
    @gooddata_project = GooddataProject.new(gooddata_project_params)

    respond_to do |format|
      if @gooddata_project.save
        flash[:success] = "Success! GooddataProject created."        
        format.html { redirect_to @gooddata_project }
        format.json { render json: @gooddata_project, status: :created }
      else
        flash[:danger] = "Error! GooddataProject not created: #{@gooddata_project.errors.full_messages}"
        format.html { render action: 'new' }
        format.json { render json: @gooddata_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gooddata_projects/1
  # PATCH/PUT /gooddata_projects/1.json
  def update
    respond_to do |format|
      if @gooddata_project.update(gooddata_project_params)
        flash[:success] = "Success! GooddataProject updated."
        format.html { redirect_to @gooddata_project }
        format.json { head :no_content }
      else
        flash[:danger] = "Error! GooddataProject not updated: #{@gooddata_project.errors.full_messages}"
        format.html { render action: 'edit' }
        format.json { render json: @gooddata_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gooddata_projects/1
  # DELETE /gooddata_projects/1.json
  def destroy
    @gooddata_project.destroy
    respond_to do |format|
      flash[:success] = 'Success! GooddataProject destroyed.'
      format.html { redirect_to gooddata_projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gooddata_project
      @gooddata_project = GooddataProject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gooddata_project_params
      params.require(:gooddata_project).permit(:name, :description, :project_uid, :client_id)
    end
end
