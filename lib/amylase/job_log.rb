module Amylase
  module JobLog
    
    # Public: Gets the job logger (uses Logging gem)
    attr_reader :job_log

    # Public: Gets the base name of the log
    attr_reader :job_log_base_name

    # Public: Hook that adds the initialize_job_log method to any class it is
    # included in.
    def self.included(klass)
      klass.job_initializers << :initialize_job_log
    end

    private

    # Private: Initialize the job log and set the instance variable @job_log
    # that should be used to log job actions.
    #
    # Returns nothing.
    def initialize_job_log
      set_log_base_name
      @log_file = File.join(Dir.tmpdir,@job_log_base_name)

      @job_log = Logging.logger['JobLog']
      @job_log.level = :info
      @job_log.add_appenders(
          Logging.appenders.stdout,
          Logging.appenders.file(@log_file)
      )

      @job_log.info "Logging temporary output to #{@log_file}"
    end


    # Private: Save any generated logs to a location in S3 specified in settings.
    # If the file is transferred successfully, the local temporary file is deleted.
    #
    # Returns nothing.
    def save_log
      return unless Settings.logging.save_logs_to_s3

      s3_bucket = AWS::S3.new.buckets[Settings.logging.s3_bucket]
      obj = s3_bucket.objects[Settings.logging.s3_root_folder + '/' + @job_log_base_name]
      obj.write(Pathname.new(@log_file))

      File.delete(@log_file)
    end

    # Private: Set the base name of the log file.
    #
    # Returns a string.
    def set_log_base_name
      @job_log_base_name = "#{Rails.env}-#{self.job_spec.name}-#{Time.now.strftime('%Y%m%d-%H%M%S%z')}-#{SecureRandom.hex(2)}.log"
    end

  end
end
