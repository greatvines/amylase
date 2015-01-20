require 'rails_helper'

RSpec.describe TplDevTest, :type => :model do
  before { @tpl = FactoryGirl.build(:tpl_dev_test) }
  subject { @tpl }

  it { should respond_to(:sleep_seconds) }
  it { should respond_to(:argument) }
  it { should have_one(:job_spec) }
  it { should be_valid }

  # All templates need to pass these tests
  it { should respond_to(:run_template) }

  # This job acts as a generic test for running templates.  These tests should
  # not be repeated in other template specs.
  describe "running the template as a job" do
    before do
      job_spec = FactoryGirl.build(:job_spec, :template_tpl_dev_test)
      @job_template = job_spec.job_template
      @launched_job = FactoryGirl.build(:launched_job, job_spec: job_spec)
      @launched_job.send(:initialize_job)
    end

    let(:run_template) { @job_template.run_template }
    let(:log_output) { @log_output.read }

    it "logs a message within the job template" do
      run_template
      expect(log_output).to match /INFO  JobLog-\w+ : Logging within TplDevTest job/
    end

    it "updates the job status message" do
      expect { run_template }.to change { @launched_job.status_message }.from(nil).to("Running TplDevTest job")
    end
  end
end
