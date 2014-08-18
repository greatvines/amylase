class JobSpecsController < ApplicationController

  def index
    @job_specs = JobSpec.all.as_json( { include: :job_template } )
  end

  def show
    @job_spec = JobSpec.find(params[:id]).as_json( { include: :job_template } )
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end



  private

end
