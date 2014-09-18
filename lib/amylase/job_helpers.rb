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

    # Public: This is the method that is called by the job handler
    # when the job is to be executed.  It wraps the run_template job
    # that is defined in and specific to individual job template
    # models.
    #
    # launched_job - An instance of LaunchedJob that tracks the status
    #                of the running job.
    #
    # Returns nothing.
    def run_job(launched_job)
      begin
        initialize_job
        self.run_template(launched_job)
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

  end
end
