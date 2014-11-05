class JobSpecsController < ApplicationController
  before_action :set_job_spec, only: [:show, :edit, :update, :destroy, :run_now]

  # GET /job_specs
  def index
    @job_specs = JobSpec.all
  end

  # GET /job_specs/1
  def show
  end

  # GET /job_specs/new
  def new
    @job_spec = JobSpec.new
  end

  # GET /job_specs/1/edit
  def edit
  end

  # GET /job_specs/show_job_template_form
  def show_job_template_form
    respond_to do |format|
      format.js
    end
  end

  #  POST /job_specs
  def create
    @job_spec = JobSpec.new(job_spec_params)
    respond_to do |format|
      if @job_spec.save
        flash[:success] = "Success! JobSpec created."
        format.html { redirect_to @job_spec }
        format.json { render :show, status: :created, location: @job_spec }
      else
        flash[:danger] = "Error! JobSpec not created: #{@job_spec.errors.full_messages}"
        format.html { render :new }
        format.json { render json: @job_spec.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_specs/1
  def update
    respond_to do |format|
      if @job_spec.update(job_spec_params)
        if JobScheduler.find
          JobScheduler.find.unschedule_job_spec(@job_spec)
          JobScheduler.find.schedule_job_spec(@job_spec) if @job_spec.enabled
        end

        flash[:success] = "Success! JobSpec updated."
        format.html { redirect_to @job_spec }
        format.json { render :show, status: :ok, location: @job_spec }
      else
        flash[:danger] = "Error! JobSpec not updated: #{@job_spec.errors.full_messages}"
        format.html { render :edit }
        format.json { render json: @job_spec.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_schedule_groups/1
  # DELETE /job_schedule_groups/1.json
  def destroy
    @job_spec.destroy
    JobScheduler.find.unschedule_job_spec(@job_spec) if JobScheduler.find

    respond_to do |format|
      flash[:success] = 'Success! JobSpec destroyed.'
      format.html { redirect_to job_specs_url }
      format.json { head :no_content }
    end
  end

  # GET /job_specs/1/run_now
  def run_now
    job_scheduler = JobScheduler.find

    unless job_scheduler
      flash[:danger] = "Error! JobScheduler not running."
      return redirect_to :back
    end

    begin
      job_scheduler.schedule_job_spec_now(@job_spec)
      redirect_to launched_jobs_path
    rescue => err
      flash[:danger] = "Error! Job not launched. #{err.class.name}: #{err.message}"
      redirect_to :back
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_spec
      @job_spec = JobSpec.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_spec_params

      # Some parameters may share the same name with different templates.  The form
      # needs unique names for each template, so we store those shared parameters
      # in a separate part of the parameter hash and then merge it back into the
      # standard location once the job template type has been established.
      if params[:job_spec][:job_template_attributes]
        params[:job_spec][:job_template_attributes].merge!(params[:job_spec][params[:job_spec][:job_template_type].underscore])
      end
      
      params.require(:job_spec).permit(:name, :enabled, :job_template_type, :job_template_id, :job_schedule_group_id, :client_id, 
        job_template_attributes: "#{params[:job_spec][:job_template_type]}::JOB_SPEC_PERMITTED_ATTRIBUTES".constantize)
    end

end
