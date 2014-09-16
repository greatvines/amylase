require 'rails_helper'

RSpec.describe TplBirstSoapGenericCommand, :type => :model do
  before do
    @tpl = TplBirstSoapGenericCommand.new(
      command:       "list_spaces",
      argument_json: ""
    )
  end

  subject { @tpl }

  it { should respond_to(:command) }
  it { should respond_to(:argument_json) }
  
  it { should validate_presence_of(:command) }

  it { should have_one(:job_spec) }

  it { should be_valid }

  # All templates need to pass these tests
  it { should respond_to(:run_job) }
  it { should respond_to(:run_template) }

  # This job should act as a test for generic Birst Web Services jobs
  describe "Birst soap logging", :live => true do

    # Since we don't get SOAP logging with Savon mock objects, we need to do a live test
    before do
      job_spec = FactoryGirl.build(:job_spec, :template_tpl_birst_soap_generic_command)
      job_spec.run_job
    end

    let(:log_output) { @log_output.read }
    
    it "logs soap messages" do
      expect(log_output).to match /INFO  JobLog : SOAP response \(status 200\)/
      expect(log_output).to match /<listSpacesResponse xmlns="http:\/\/www.birst.com\/">/
      expect(log_output).to match /<listSpacesResult>/
      expect(log_output).to match /<UserSpace>/
    end

  end


end
