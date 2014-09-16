module Amylase

  # Public: The JobHelpers module is intended to be included in any JobTemplate
  # classes.
  #
  # Examples
  #
  #   class TplDevTest < ActiveRecord::Base
  #     has_one :job_spec, as: :job_template
  #     include Amylase::JobHelpers
  #   end
  module JobHelpers

    # Public: Gets the job logger (uses Logging gem)
    attr_reader :job_log

    # Public: Gets the base name of the log
    attr_reader :job_log_base_name

    def run_job
      begin
        initialize_job
        self.run_template
      rescue => err
        @job_log.error "Backtrace: #{err.class.name}: #{$!}\n\t#{err.backtrace.join("\n\t")}"
        raise err
      ensure
        save_log
        nil
      end
    end



    def initialize_job
      initialize_job_log
    end

    def initialize_job_log
      set_log_base_name
      @log_file = File.join(Dir.tmpdir,@job_log_base_name)

      @job_log = Logging.logger['JobLog']
      @job_log.level = :info
      @job_log.add_appenders(
          Logging.appenders.stdout,
          Logging.appenders.file(@log_file)
      )

      @job_log.info "Starting job #{self.job_spec.name} using template #{self.job_spec.job_template_type}"
      @job_log.info "Logging to file #{@log_file}"
    end


    def save_log
      return unless Settings.logging.save_logs_to_s3

      s3_bucket = AWS::S3.new.buckets[Settings.logging.s3_bucket]
      obj = s3_bucket.objects[Settings.logging.s3_root_folder + '/' + @job_log_base_name]
      obj.write(Pathname.new(@log_file))

      File.delete(@log_file)
    end

    private

    # Private: Set the base name of the log file.
    #
    # Returns a string.
    def set_log_base_name
      @job_log_base_name = "#{Rails.env}-#{self.job_spec.name}-#{Time.now.strftime('%Y%m%d-%H%M%S%z')}-#{SecureRandom.hex(2)}.log"
    end
  end
end
