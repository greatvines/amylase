require 'rails_helper'

RSpec.describe JobScheduleGroup, :type => :model do
  before { @job_schedule_group = FactoryGirl.create(:job_schedule_group) }
  subject { @job_schedule_group }

  it { should respond_to(:name) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should ensure_length_of(:name).is_at_least(3).is_at_most(255) }
  it { should have_many(:job_schedules).dependent(:destroy) }
  it { should have_many(:job_specs) }
  it { should accept_nested_attributes_for(:job_schedules) }
  it { should be_valid }
end
