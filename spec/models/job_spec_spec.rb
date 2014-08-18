require 'rails_helper'

RSpec.describe JobSpec, :type => :model do
  before do
    @job_spec = JobSpec.new(
      name:    "a_fascinating_job"
    )
  end

  subject { @job_spec }

  it { should respond_to(:name) }
  it { should respond_to(:enabled) }

  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }

  it { should belong_to(:job_template) }
  
  it { should be_valid }

  describe "default values" do
    specify { expect(@job_spec.enabled).to eq false }
  end
end
