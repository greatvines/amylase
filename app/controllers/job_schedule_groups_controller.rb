class JobScheduleGroupsController < ApplicationController
  before_action :set_job_schedule_group, only: [:show, :edit, :update, :destroy]

  # GET /job_schedule_groups
  # GET /job_schedule_groups.json
  def index
    @job_schedule_groups = JobScheduleGroup.all
  end

  # GET /job_schedule_groups/1
  # GET /job_schedule_groups/1.json
  def show
  end

  # GET /job_schedule_groups/new
  def new
    @job_schedule_group = JobScheduleGroup.new
  end

  # GET /job_schedule_groups/1/edit
  def edit
  end

  # POST /job_schedule_groups
  # POST /job_schedule_groups.json
  def create
    @job_schedule_group = JobScheduleGroup.new(job_schedule_group_params)
    respond_to do |format|
      if @job_schedule_group.save
        flash[:success] = "Success! JobScheduleGroup created."
        format.html { redirect_to @job_schedule_group }
        format.json { render :show, status: :created, location: @job_schedule_group }
      else
        flash[:danger] = "Error! JobScheduleGroup not created: #{@job_schedule_group.errors.full_messages}"
        format.html { render :new }
        format.json { render json: @job_schedule_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_schedule_groups/1
  # PATCH/PUT /job_schedule_groups/1.json
  def update
    respond_to do |format|
      if @job_schedule_group.update(job_schedule_group_params)
        flash[:success] = "Success! JobScheduleGroup updated."
        format.html { redirect_to @job_schedule_group }
        format.json { render :show, status: :ok, location: @job_schedule_group }
      else
        flash[:danger] = "Error! JobScheduleGroup not updated: #{@job_schedule_group.errors.full_messages}"
        format.html { render :edit }
        format.json { render json: @job_schedule_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_schedule_groups/1
  # DELETE /job_schedule_groups/1.json
  def destroy
    @job_schedule_group.destroy
    respond_to do |format|
      format.html { redirect_to job_schedule_groups_url, notice: 'Job schedule group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_schedule_group
      @job_schedule_group = JobScheduleGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_schedule_group_params
      params.require(:job_schedule_group).permit(:name, job_schedules_attributes: [:id, :job_schedule_group_id, :_destroy, :schedule_method, :schedule_time, :first_at, :last_at, :number_of_times])
    end
end
