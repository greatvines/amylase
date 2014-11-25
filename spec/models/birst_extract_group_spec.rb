require 'rails_helper'

RSpec.describe BirstExtractGroup, :type => :model do
  before { @birst_extract_group = FactoryGirl.create(:birst_extract_group) }
  subject { @birst_extract_group }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should be_valid }

  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }
end
