class LaunchedJobsController < ApplicationController
  before_action :set_launched_job, only: [:show, :edit, :update, :destroy]

  # GET /launched_jobs
  # GET /launched_jobs.json
  def index
    @launched_jobs = LaunchedJob.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @launched_jobs }
    end
  end

  # GET /launched_jobs/1
  # GET /launched_jobs/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @launched_job }
    end
  end

  # GET /launched_jobs/new
  def new
    @launched_job = LaunchedJob.new
  end

  # GET /launched_jobs/1/edit
  def edit
  end

  # POST /launched_jobs
  # POST /launched_jobs.json
  def create
    @launched_job = LaunchedJob.new(launched_job_params)

    respond_to do |format|
      if @launched_job.save
        format.html { redirect_to @launched_job, notice: 'Launched job was successfully created.' }
        format.json { render json: @launched_job, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @launched_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /launched_jobs/1
  # PATCH/PUT /launched_jobs/1.json
  def update
    respond_to do |format|
      if @launched_job.update(launched_job_params)
        format.html { redirect_to @launched_job, notice: 'Launched job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @launched_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /launched_jobs/1
  # DELETE /launched_jobs/1.json
  def destroy
    @launched_job.destroy
    respond_to do |format|
      format.html { redirect_to launched_jobs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_launched_job
      @launched_job = LaunchedJob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def launched_job_params
      params.require(:launched_job).permit(:job_spec_id, :start_time, :end_time, :status, :status_message, :result_data, :log_file)
    end
end
