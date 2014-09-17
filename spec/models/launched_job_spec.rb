require 'rails_helper'

RSpec.describe LaunchedJob, :type => :model do
  before { @launched_job = FactoryGirl.create(:launched_job) }
  subject { @launched_job }

  it { should respond_to(:job_spec) }
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }
  it { should respond_to(:status) }
  it { should respond_to(:status_message) }
  it { should respond_to(:result_data) }
  it { should respond_to(:log_file) }
  it { should be_valid }

  it { should validate_inclusion_of(:status).in_array(LaunchedJob::STATUS_VALUES) }

  it { should belong_to(:job_spec) }

  describe "default values" do
    specify "status has the correct default" do
      expect(@launched_job.status).to eq LaunchedJob::UNKNOWN
    end
  end


  describe "the job lifecycle a job" do
    before { @launched_job = FactoryGirl.build(:launched_job, :with_tpl_dev_test_job_spec) }

    context "initial launch" do
      let(:launch_job) { @launched_job.launch_job }

      it "saves the launched job instance" do
        expect { launch_job }.to change { @launched_job.persisted? }.from(false).to(true)
      end

      it "sets the status to running" do
        expect { launch_job }.to change { @launched_job.status }.from(LaunchedJob::UNKNOWN).to(LaunchedJob::RUNNING)
      end

      it "sets the start time to now (within 1 sec)" do
        expect { launch_job }.to change { @launched_job.start_time }.from(nil).to(be_within(1.0).of(Time.now))
      end
    end

    context "actively running" do
      let(:running_job) { @launched_job.launch_job }
      it "allows status message updates while running" do
        expect { running_job }.to change { @launched_job.status_message }.from(nil).to("Running TplDevTest job")
      end

      it "does not have an end time" do
        expect(running_job.end_time).to be_nil
      end

      it "reports a valid run_time" do
        expect(running_job.run_time).to be > 0
      end
    end

    context "termination" do
      before { @launched_job.launch_job }
      let(:terminated_job) { @launched_job.terminate_job }

      shared_examples "a terminated job" do
        it "sets the end time to now (within 1 sec)" do
          expect { terminated_job }.to change { @launched_job.end_time }.from(nil).to(be_within(1.0).of(Time.now))
        end
      end
      
      shared_examples "a failed terminated job" do
        it "changes the status to ERROR" do
          expect { terminated_job }.to change { @launched_job.status }.from(termination_status).to(LaunchedJob::ERROR)
        end

        it "prepends an error message" do
          expect(terminated_job.status_message).to match(/#{termination_status} job terminated\|/)
        end
      end

      context "terminating a successful job" do
        before { @launched_job.update(status: LaunchedJob::SUCCESS) }
        it_behaves_like "a terminated job"
      end

      context "terminating a running job" do
        before { @launched_job.update(status: LaunchedJob::RUNNING) }
        let(:termination_status) { LaunchedJob::RUNNING }

        it_behaves_like "a terminated job"
        it_behaves_like "a failed terminated job"

      end

      context "terminating an unknown job" do
        before { @launched_job.update(status: LaunchedJob::UNKNOWN) }
        let(:termination_status) { LaunchedJob::UNKNOWN }

        it_behaves_like "a terminated job"
        it_behaves_like "a failed terminated job"
      end
    end

  end
end
