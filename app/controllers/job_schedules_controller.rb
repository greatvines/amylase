class JobSchedulesController < ApplicationController
  before_action :set_job_schedule, only: [:show, :edit, :update, :destroy]

  # GET /job_schedules
  # GET /job_schedules.json
  def index
    @job_schedules = JobSchedule.all
  end

  # GET /job_schedules/1
  # GET /job_schedules/1.json
  def show
  end

  # GET /job_schedules/new
  def new
    @job_schedule = JobSchedule.new
  end

  # GET /job_schedules/1/edit
  def edit
  end

  # POST /job_schedules
  # POST /job_schedules.json
  def create
    @job_schedule = JobSchedule.new(job_schedule_params)

    respond_to do |format|
      if @job_schedule.save
        format.html { redirect_to @job_schedule, notice: 'Job schedule was successfully created.' }
        format.json { render :show, status: :created, location: @job_schedule }
      else
        format.html { render :new }
        format.json { render json: @job_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_schedules/1
  # PATCH/PUT /job_schedules/1.json
  def update
    respond_to do |format|
      if @job_schedule.update(job_schedule_params)
        format.html { redirect_to @job_schedule, notice: 'Job schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_schedule }
      else
        format.html { render :edit }
        format.json { render json: @job_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_schedules/1
  # DELETE /job_schedules/1.json
  def destroy
    @job_schedule.destroy
    respond_to do |format|
      format.html { redirect_to job_schedules_url, notice: 'Job schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_schedule
      @job_schedule = JobSchedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_schedule_params
      params.require(:job_schedule).permit(:schedule_method, :schedule_time, :first_at, :last_at)
    end
end
