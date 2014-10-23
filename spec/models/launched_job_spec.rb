require 'rails_helper'

RSpec.describe LaunchedJob, :type => :model do
  before { @launched_job = FactoryGirl.create(:launched_job) }
  subject { @launched_job }

  it { should respond_to(:job_spec) }
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }
  it { should respond_to(:status) }
  it { should respond_to(:status_message) }
  it { should respond_to(:status_priority) }
  it { should respond_to(:result_data) }
  it { should respond_to(:log_file) }
  it { should be_valid }

  it { should validate_inclusion_of(:status).in_array(LaunchedJob::STATUS_VALUES) }

  it { should belong_to(:job_spec) }

  describe "default values" do
    specify "status has the correct default" do
      expect(@launched_job.status).to eq LaunchedJob::UNKNOWN
    end

    specify "status has the correct priority" do
      expect(@launched_job.status_priority).to eq LaunchedJob::STATUS_PRIORITY_MAP[@launched_job.status]
    end

  end


  describe "the job lifecycle" do
    before { @launched_job = FactoryGirl.build(:launched_job, :with_tpl_dev_test_job_spec) }

    context "initialization" do
      before { @launched_job.send(:initialize_job) }
      let(:log_result) { @log_output.read }

      it "initializes the job log" do
        expect(log_result).to match /INFO  JobLog : Logging temporary output to .*#{@launched_job.job_log_base_name}.*/
      end
    end

    context "initial status" do
      before { @launched_job.send(:initialize_job) }
      let(:set_initial_status) { @launched_job.send(:set_initial_status) }

      it "saves the launched job instance" do
        expect { set_initial_status }.to change { LaunchedJob.count }.by(1)
      end

      it "sets the status to running" do
        expect { set_initial_status }.to change { @launched_job.status }.from(LaunchedJob::UNKNOWN).to(LaunchedJob::RUNNING)
      end

      it "sets the start time to now (within 1 sec)" do
        expect { set_initial_status }.to change { @launched_job.start_time }.from(nil).to(be_within(1.0).of(Time.now))
      end
    end

    context "running the job template" do
      before do
        @launched_job.send(:initialize_job)
        @launched_job.send(:set_initial_status)
      end
      let(:run_job_template) { @launched_job.send(:run_job_template) }

      it "allows status message updates while running" do
        expect { run_job_template }.to change { @launched_job.status_message }.from(nil).to("Running TplDevTest job")
      end

      it "does not have an end time" do
        run_job_template
        expect(@launched_job.end_time).to be_nil
      end

      it "reports a valid run_time" do
        run_job_template
        expect(@launched_job.run_time).to be > 0
      end
    end

    context "handling an error" do
      before do
        @launched_job.send(:initialize_job)
        @launched_job.send(:set_initial_status)
      end
      let(:err) {
        err = RuntimeError.new("some error")
        err.set_backtrace(Array("dummy backtrace"))
        err
      }
      let(:job_error_handler) { @launched_job.send(:job_error_handler, err) }

      it "updates the status to error" do
        expect{ job_error_handler rescue nil }.to change { @launched_job.status }.from(LaunchedJob::RUNNING).to(LaunchedJob::ERROR)
      end

      it "re-raises the error" do
        expect{ job_error_handler }.to raise_error('some error')
      end
    end

    context "closing the job" do
      before do
        @launched_job.send(:initialize_job)
        @launched_job.send(:set_initial_status)
        @launched_job.send(:run_job_template)
      end
      let(:close_job) { @launched_job.send(:close_job) }

      shared_examples "all closed jobs" do
        it "sets the end time to now (within 1 sec)" do
          expect { close_job }.to change { @launched_job.end_time }.from(nil).to(be_within(1.0).of(Time.now))
        end
        
        context "saving logs" do
          before do
            @save_log_settings = Settings.logging.save_logs_to_s3
            Settings.logging.save_logs_to_s3 = true
            close_job
          end

          let(:s3_obj) do
            s3_bucket = AWS::S3.new.buckets[Settings.logging.s3_bucket]
            s3_bucket.objects[Settings.logging.s3_root_folder + '/' + @launched_job.job_log_base_name]
          end

          after do
            Settings.logging.save_logs_to_s3 = @save_log_settings
            s3_obj.delete
          end

          it "saves the log to s3" do
            expect(s3_obj).to exist
          end
        end
      end


      context "closing a RUNNING job" do
        before { @launched_job.update(status: LaunchedJob::RUNNING) }
        it_behaves_like "all closed jobs"

        it "changes the status to SUCCESS" do
          expect { close_job }.to change { @launched_job.status }.from(LaunchedJob::RUNNING).to(LaunchedJob::SUCCESS)
        end

        it "sets the status message to indicate success" do
          expect { close_job }.to change { @launched_job.status_message }.to("Completed successfully")
        end
      end

      context "closing an ERROR job" do
        before { @launched_job.update(status: LaunchedJob::ERROR, status_message: "some error") }
        it_behaves_like "all closed jobs"
      end

      context "closing an UNKNOWN job" do
        before { @launched_job.update(status: LaunchedJob::UNKNOWN, status_message: "something") }
        it_behaves_like "all closed jobs"

        it "changes the status to ERROR" do
          expect { close_job }.to change { @launched_job.status }.from(LaunchedJob::UNKNOWN).to(LaunchedJob::ERROR)
        end

        it "sets the status message to indicate unknown" do
          expect { close_job }.to change { @launched_job.status_message }.to("UNKNOWN job terminated")
        end
      end
    end

    context "the full lifecycle" do
      let(:run_job) { @launched_job.run_job }

      it "runs as expected without an error" do
        expect(@launched_job).to receive(:initialize_job).once.and_call_original
        expect(@launched_job).to receive(:set_initial_status).once.and_call_original
        expect(@launched_job).to receive(:run_job_template).once.and_call_original
        expect(@launched_job).not_to receive(:job_error_handler).and_call_original
        expect(@launched_job).to receive(:close_job).once.and_call_original
        run_job
      end

      it "calls the error handler when there is an error" do
        allow(@launched_job).to receive(:run_job_template) { raise "some error" }

        expect(@launched_job).to receive(:initialize_job).once.and_call_original
        expect(@launched_job).to receive(:set_initial_status).once.and_call_original
        expect(@launched_job).to receive(:run_job_template).once
        expect(@launched_job).to receive(:job_error_handler).and_call_original
        expect(@launched_job).to receive(:close_job).once.and_call_original
        run_job rescue nil
      end


    end
  end
end
