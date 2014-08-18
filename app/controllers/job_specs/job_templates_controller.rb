class JobSpecs::JobTemplatesController < ApplicationController

  def show
    @job_template = JobSpec.find(params[:job_spec_id]).job_template
  end

end
