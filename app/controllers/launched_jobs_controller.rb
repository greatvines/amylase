class LaunchedJobsController < ApplicationController
  before_action :set_launched_job, only: [:show, :edit, :update, :destroy, :show_job_log, :rerun, :kill_job]

  # GET /launched_jobs
  # GET /launched_jobs.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: LaunchedJobDatatable.new(view_context, min_start_date: params[:min_start_date]) }
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

  # GET /launched_jobs/1/job_log
  def show_job_log
    s3_path = @launched_job.log_file

    if s3_path.blank?
      flash[:danger] = "Error! Job log not found."
      redirect_to @launched_job
    else
      bucket_name = s3_path[/s3:\/\/([\w-]+)\//,1]
      object_name = s3_path[/s3:\/\/[\w-]+\/(.*)/,1]

      s3_bucket = AWS::S3.new.buckets[bucket_name]
      obj = s3_bucket.objects[object_name]
      redirect_to obj.url_for(:read, :expires => 2.minutes).to_s
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

  # GET /launched_jobs/1/rerun
  def rerun
    redirect_to job_specs_run_now_path(@launched_job.job_spec.id)
  end

  # GET /launched_jobs/1/kill_job
  def kill_job
    begin
      @launched_job.kill_job
      redirect_to :back
    rescue => err
      flash[:danger] = "Error! Unable to kill job: #{err.class.name}: #{err.message}"
      redirect_to :back
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
