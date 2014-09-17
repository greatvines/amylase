class LaunchedJob < ActiveRecord::Base
  belongs_to :job_spec
end
