module Amylase
  module TemplateHelpers
    attr_accessor :job_initializers

    def self.extended(klass)
      klass.job_initializers = [:initialize_job_log]
    end

  end
end
