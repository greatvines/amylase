class JobSpecs::TplBirstSoapGenericCommandsController < ApplicationController

  def show
    @job_template = JobSpec.find(params[:job_spec_id]).job_template
  end

  def new
    @job_template = ::TplBirstSpoapGenericCommand.new
  end


  private

    def tpl_birst_soap_generic_command_params
      params.require(:tpl_birst_soap_generic_command).permit(:command, :argument_json, job_spec_attributes: JobSpecs::JOB_SPEC_PERMITTED)
    end

end
