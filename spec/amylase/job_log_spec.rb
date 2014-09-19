require 'rails_helper'

describe Amylase::JobLog do
  extend Amylase::JobInitializers
  include Amylase::JobLog

  # This usually creates a name with the job spec name in it, so stub it so we don't need one
  def set_log_base_name
      @job_log_base_name = "#{Rails.env}-job_log_spec-#{Time.now.strftime('%Y%m%d-%H%M%S%z')}-#{SecureRandom.hex(2)}.log"
  end

  before do
    initialize_job_log
    @job_log.info "This is a logging message"
  end

  let(:log_result) { @log_output.read }

  it "logs messages to the JobLog logging channel" do
    expect(log_result).to match /INFO  JobLog : This is a logging message/
  end

  it "logs the name of the temporary output file" do
    expect(log_result).to match /INFO  JobLog : Logging temporary output to .*#{@job_log_base_name}.*/
  end

  describe "saving logs to s3" do
    before do
      @save_log_settings = Settings.logging.save_logs_to_s3
      Settings.logging.save_logs_to_s3 = true
    end

    let(:s3_obj) do
      s3_bucket = AWS::S3.new.buckets[Settings.logging.s3_bucket]
      s3_bucket.objects[Settings.logging.s3_root_folder + '/' + @job_log_base_name]
    end

    after do
      Settings.logging.save_logs_to_s3 = @save_log_settings
      s3_obj.delete
    end


    context "successful save to s3" do
      before { close_job_log }

      it "saves the log to s3" do
        expect(s3_obj).to exist
      end

      it "removes the local temporary file after a save" do
        expect(Pathname.new(@log_file)).not_to exist
      end
    end

    context "unsuccessful save to s3" do
      before do
        allow(self).to receive(:save_log) { raise "some error" }
        close_job_log rescue nil
      end

      it "does not remove the local temporary file" do
        expect(Pathname.new(@log_file)).to exist
      end
      
    end

  end
end
