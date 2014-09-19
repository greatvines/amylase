require 'rails_helper'

RSpec.describe TplBirstSoapGenericCommand, :type => :model do
  include BirstSoapSupport

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
  it { should respond_to(:run_template) }

  # This job should act as a test for generic Birst Web Services jobs
  describe "running birst soap generic commands as a job" do
    before do
      job_spec = FactoryGirl.build(:job_spec, :template_tpl_birst_soap_generic_command)
      @job_template = job_spec.job_template
      @launched_job = FactoryGirl.build(:launched_job, job_spec: job_spec)
      @launched_job.send(:initialize_job)
    end

    let(:run_template) { @job_template.run_template }

    describe "Birst SOAP logging", :live => true do
      # Since we don't get SOAP logging with Savon mock objects, we need to do a live test

      it "logs SOAP messages" do
        run_template
        log_output = @log_output.read
        expect(log_output).to match /INFO  JobLog : SOAP response \(status 200\)/
        expect(log_output).to match /<listSpacesResponse xmlns="http:\/\/www.birst.com\/">/
        expect(log_output).to match /<listSpacesResult>/
        expect(log_output).to match /<UserSpace>/
      end
    end

    describe "capturing result data" do
      before { savon.mock! }
      after { savon.unmock! }

      it "captured some data" do
        mock_login_and_out do
          savon.expects(:list_spaces)
            .with(message: { :token => BirstSoapFixtures.login_token })
            .returns(BirstSoapFixtures.list_spaces)
        end

        run_template
        expect(JSON.parse(@launched_job.result_data)['user_space']).to eq Hash.from_xml(BirstSoapFixtures.list_spaces)['Envelope']['Body']['listSpacesResponse']['listSpacesResult']['UserSpace']
      end
    end
  end
end
