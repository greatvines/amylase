class JobSchedulersController < ApplicationController
  before_action :set_job_scheduler, only: [:show, :edit, :update, :destroy]

  # GET /job_schedulers
  # GET /job_schedulers.json
  def index
    @job_schedulers = JobScheduler.all
  end

  # GET /job_schedulers/1
  # GET /job_schedulers/1.json
  def show
  end

  # GET /job_schedulers/new
  def new
    @job_scheduler = JobScheduler.new
  end

  # GET /job_schedulers/1/edit
  def edit
  end

  # POST /job_schedulers
  # POST /job_schedulers.json
  def create
    @job_scheduler = JobScheduler.new(job_scheduler_params)

    respond_to do |format|
      if @job_scheduler.save
        flash[:success] = "Success! JobScheduler created."
        format.html { redirect_to job_scheduler_url(@job_scheduler) }
        format.json { render :show, status: :created, location: job_scheduler_url(@job_scheduler) }
      else
        flash[:danger] = "Error! There was a problem creating the Scheduler."
        @job_scheduler.destroy
        format.html { render :new }
        format.json { render json: @job_scheduler.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_schedulers/1
  # PATCH/PUT /job_schedulers/1.json
  def update
    respond_to do |format|
      if @job_scheduler.update(job_scheduler_params)
        format.html { redirect_to @job_scheduler, notice: 'Job scheduler was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_scheduler }
      else
        format.html { render :edit }
        format.json { render json: @job_scheduler.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_schedulers/1
  # DELETE /job_schedulers/1.json
  def destroy
    @job_scheduler.destroy
    flash[:success] = "Success! JobScheduler destroyed."      
    redirect_to job_scheduler_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_scheduler
      @job_scheduler = JobScheduler.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_scheduler_params
      params.require(:job_scheduler).permit(:id, :timeout)
    end
end
