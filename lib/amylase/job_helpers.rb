module Amylase

  # Public: The JobHelpers module is intended to be included in any JobTemplate
  # classes.  It needs to be included after the class is extended by TemplateHelpers.
  #
  # Examples
  #
  #   class TplDevTest < ActiveRecord::Base
  #     has_one :job_spec, as: :job_template
  #     extend Amylase::TemplateHelpers
  #     include Amylase::JobHelpers
  #   end
  module JobHelpers

    # Public: Gets the job logger (uses Logging gem)
    attr_reader :job_log

    # Public: Gets the base name of the log
    attr_reader :job_log_base_name

    # Public: This is the method that is called by the job handler
    # when the job is to be executed.  It wraps the run_template job
    # that is defined in and specific to individual job template
    # models.
    #
    # Returns nothing.
    def run_job
      begin
        initialize_job
        self.run_template
      rescue => err
        @job_log.error "Backtrace: #{err.class.name}: #{$!}\n\t#{err.backtrace.join("\n\t")}"
        raise err
      ensure
        close_job
        nil
      end
    end



    private

    # Private: This method is run before the specific run_template method is executed.
    # It is used to intialize any instance variables that may need to be set before
    # running the job.  Any modules included the job template model that need
    # initialization should append the name of the initialization method to 
    # the job template class job_initializers.
    #
    # Examples
    #
    #   module BirstSoap
    #     def self.included(klass)
    #       klass.job_initializers << :initialize_birst_soap
    #     end
    #   end
    #
    # Returns nothing.
    def initialize_job
      self.class.job_initializers.each do |job_initializer|
        self.send(job_initializer)
      end
    end


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

      @job_log.info "Starting job #{self.job_spec.name} using template #{self.job_spec.job_template_type}"
      @job_log.info "Logging to file #{@log_file}"
    end

    # Private: This is run after the specific run_template method is executed,
    # even if there are errors.
    #
    # Returns nothing.
    def close_job
      save_log
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
