require 'rails_helper'

RSpec.describe TplDevTest, :type => :model do
  before { @tpl = FactoryGirl.build(:tpl_dev_test) }
  subject { @tpl }

  it { should respond_to(:argument) }
  it { should validate_presence_of(:argument) }
  it { should have_one(:job_spec) }
  it { should be_valid }

  # All templates need to pass these tests
  it { should respond_to(:run_job) }
  it { should respond_to(:run_template) }


  describe "job logging" do

    before { @job_spec = FactoryGirl.build(:job_spec, :template_tpl_dev_test) }

    shared_context "unsuccessful run" do
      before do
        job_template = @job_spec.job_template
        def job_template.run_template
          raise "Testing an error"
        end
      end
    end

    context "successful run" do
      before { @job_spec.run_job }

      it "logs the start of a job" do
        expect(@log_output.readline.strip.chomp).to eq 'INFO  JobLog : Starting job job_spec_collection-\d+ using template TplDevTest'
      end
    end

    context "unsuccessful run" do
      include_context "unsuccessful run"

      it "raises an error" do
        expect { @job_spec.run_job }.to raise_error "Testing an error"
      end

      it "logs an error" do
        @job_spec.run_job rescue nil
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
        s3_bucket.objects[Settings.logging.s3_root_folder + '/' + @job_spec.job_template.job_log_base_name]
      end

      after { Settings.logging.save_logs_to_s3 = @save_log_settings }


      context "successful run" do
        before { @job_spec.run_job }

        it "saves the log to s3" do
          expect(s3_obj).to exist
        end
      end

      context "unsuccessful run" do
        include_context "unsuccessful run"

        it "still saves the log to s3" do
          @job_spec.run_job rescue nil
          expect(s3_obj).to exist
        end
      end
    end
  end
end
