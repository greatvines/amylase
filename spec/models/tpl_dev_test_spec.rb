require 'rails_helper'

RSpec.describe TplDevTest, :type => :model do
  before { @tpl = FactoryGirl.build(:tpl_dev_test) }
  subject { @tpl }

  it { should respond_to(:argument) }
  it { should validate_presence_of(:argument) }
  it { should have_one(:job_spec) }
  it { should be_valid }

  # All templates need to pass these tests
  it { should respond_to(:run_job) }

end
