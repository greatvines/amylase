require 'rails_helper'

RSpec.describe TplDevTest, :type => :model do
  before { @tpl = FactoryGirl.build(:tpl_dev_test) }
  subject { @tpl }

  it { should respond_to(:argument) }
  it { should validate_presence_of(:argument) }
  it { should have_one(:job_spec) }
  it { should be_valid }

  # All templates need to pass these tests
  it { should respond_to(:run_template) }


  # Thinking that most of this log testing should go into a separate spec.
  # I should just have a "it runs" test.

  describe "job logging" do

    before do
      job_spec = FactoryGirl.build(:job_spec, :template_tpl_dev_test)
      @job_template = job_spec.job_template
      @launched_job = FactoryGirl.build(:launched_job, job_spec: job_spec)
      @launched_job.initialize_job
    end

    let(:run_template) { @job_template.run_template(@launched_job) }


    shared_context "unsuccessful run" do
      before do
        def @job_template.run_template(*args)
          raise "Testing an error"
        end
      end
    end


    context "successful run" do
      before { run_template }
      let(:log_output) { @log_output.read }

      it "logs the start of a job from the job launcher" do
        expect(log_output).to match /INFO  JobLog : Starting job job_spec_collection-\d+ using template TplDevTest/
      end

      it "logs the job messages within the running template" do
        expect(log_output).to match /INFO  JobLog : Logging within TplDevTest job/
      end
    end

    context "unsuccessful run" do
      include_context "unsuccessful run"

      it "raises an error" do
        expect { run_template }.to raise_error "Testing an error"
      end

      it "logs an error" do
        run_template rescue nil
        expect(@log_output.read).to match(/ERROR  JobLog : Backtrace: RuntimeError: Testing an error/)
      end
    end


    describe "saving logs to s3" do
      before do
        @save_log_settings = Settings.logging.save_logs_to_s3
        Settings.logging.save_logs_to_s3 = true
      end

      let(:s3_obj) do
        s3_bucket = AWS::S3.new.buckets[Settings.logging.s3_bucket]
        s3_bucket.objects[Settings.logging.s3_root_folder + '/' + @launched_job.job_log_base_name]
      end

      after { Settings.logging.save_logs_to_s3 = @save_log_settings }


      context "successful run" do
        before { run_template }

        it "saves the log to s3" do
          expect(s3_obj).to exist
        end
      end

      context "unsuccessful run" do
        include_context "unsuccessful run"

        it "still saves the log to s3" do
          run_template rescue nil
          expect(s3_obj).to exist
        end
      end
    end
  end
end
