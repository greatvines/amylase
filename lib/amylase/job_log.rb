module Amylase
  module JobLog

    # Public: Gets the job logger (uses Logging gem)
    attr_reader :job_log

    # Public: Gets the base name of the log
    attr_reader :job_log_base_name

    # Public: Get the name of the log file
    attr_reader :job_log_file

    # Public: Full path to the
    attr_reader :job_log_s3_full_path

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
      @job_log_file = File.join(Dir.tmpdir, @job_log_base_name)
      @job_log_s3_path = Settings.logging.s3_root_folder + '/' + @job_log_base_name
      @job_log_s3_full_path = 's3://' + Settings.logging.s3_bucket + '/' + @job_log_s3_path

      log_pattern = '[%d] %-5l %c: %m\n'

      Logging.color_scheme( 'trafficlight',
        :levels => {
          :info  => :green,
          :warn  => :yellow,
          :error => :red,
          :fatal => [:white, :on_red]
        }
      )

      Logging.appenders.stdout(
        'stdout',
        :layout => Logging.layouts.pattern(
          :pattern => log_pattern,
          :color_scheme => 'trafficlight'
        )
      )
      Logging.logger(STDOUT).close
      @job_log = Logging.logger["JobLog-#{self.try(:id).blank? ? SecureRandom.hex(2) : self.id}"]
      @job_log.clear_appenders
      @job_log.level = :info
      @job_log.add_appenders(
          Logging.appenders.stdout,
          Logging.appenders.file(@job_log_file, :layout => Logging.layouts.pattern(:pattern => log_pattern))
      )

      @job_log.info "Logging temporary output to #{@job_log_file}"
    end

    # Private: Save the log and delete any local temporary files.
    #
    # Returns nothing.
    def close_job_log
      @job_log.info "Closing log"
      save_log
      delete_local_log_file
    end


    # Private: Save any generated logs to a location in S3 specified in settings.
    #
    # Returns nothing.
    def save_log
      return unless Settings.logging.save_logs_to_s3

      s3_bucket = AWS::S3.new.buckets[Settings.logging.s3_bucket]
      obj = s3_bucket.objects[@job_log_s3_path]
      obj.write(Pathname.new(@job_log_file))
    end

    # Private: Delete the local temporary file log.
    #
    # Returns nothing.
    def delete_local_log_file
      File.delete(@job_log_file)
    end

    # Private: Set the base name of the log file.
    #
    # Returns a string.
    def set_log_base_name
      @job_log_base_name = "#{Rails.env}-#{self.job_spec.name}-#{Time.now.strftime('%Y%m%d-%H%M%S%z')}-#{SecureRandom.hex(2)}.log"
    end

  end
end
