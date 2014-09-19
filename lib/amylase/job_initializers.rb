module Amylase

  # Public: The TemplateHelpers class is meant to extend any job template classes.
  # It should be added before including any other job helpers.
  # Examples
  #
  #   class TplBirstSoapGenericCommand < ActiveRecord::Base
  #     has_one :job_spec, as: :job_template
  #     extend Amylase::TemplateHelpers
  #     include Amylase::JobHelpers
  #     include Amylase::BirstSoap
  #   end
  module JobInitializers
    
    # Public: Gets/sets the list of job initializers to call before running a job.
    attr_accessor :job_initializers

    # Public: Hook that initializes the job_initializers variable when it
    # first extends a class.
    #
    # Returns nothing.
    def self.extended(klass)
      klass.job_initializers = Array.new
    end

  end
end
