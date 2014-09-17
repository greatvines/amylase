require 'rails_helper'

RSpec.describe LaunchedJob, :type => :model do
  before { @launched_job = FactoryGirl.create(:launched_job) }
  subject { @launched_job }

  it { should respond_to(:job_spec) }
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }
  it { should respond_to(:status) }
  it { should respond_to(:status_message) }
  it { should respond_to(:result_data) }
  it { should respond_to(:log_file) }
  it { should be_valid }

  it { should validate_inclusion_of(:status).in_array(LaunchedJob::STATUS_VALUES) }

  it { should belong_to(:job_spec) }

  describe "default values" do
    specify "status has the correct default" do
      expect(@launched_job).to eq LaunchedJob::UNKNOWN
    end
  end

end
