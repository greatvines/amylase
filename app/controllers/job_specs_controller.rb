class JobSpecsController < ApplicationController

  def index
    @job_specs = JobSpec.all.as_json( { include: :job_template } )
  end

  def show
    @job_spec = JobSpec.find(params[:id]).as_json( { include: :job_template } )
  end

  def new
    @job_spec = JobSpec.new
  end

  def create
    @job_spec = JobSpec.new(job_spec_params)
    if @job_spec.save
      redirect_to home_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end



  private

end
