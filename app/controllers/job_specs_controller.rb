class JobSpecsController < ApplicationController
  before_action :set_job_spec, only: [:show, :edit, :update, :destroy]

  def index
    @job_specs = JobSpec.all
  end

  def show
  end

  def new
    @job_spec = JobSpec.new
  end

  def create
    @job_spec = JobSpec.new(job_spec_params)
    if @job_spec.save
      flash[:success] = "Success! Job Spec created."
      redirect_to @job_spec
    else
      flash[:danger] = "Error! Job Spec not created: #{@job_spec.errors.full_messages}"
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  private

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_spec
      @job_spec = JobSpec.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_spec_params
      tpl_attributes = (
        TplBirstSoapGenericCommand::JOB_SPEC_PERMITTED_ATTRIBUTES +
        TplBirstDuplicateSpace::JOB_SPEC_PERMITTED_ATTRIBUTES
      )

      params.require(:job_spec).permit(:name, :enabled, :job_template_type, job_template_attributes: tpl_attributes.uniq)
    end

end
