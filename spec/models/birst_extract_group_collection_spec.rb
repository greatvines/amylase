require 'rails_helper'

RSpec.describe BirstExtractGroupCollection, :type => :model do
  before { @birst_extract_group_collection = FactoryGirl.create(:birst_extract_group_collection) }
  subject { @birst_extract_group_collection }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should be_valid }

  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }

  it { should have_many(:birst_extract_group_collection_associations).dependent(:destroy) }
  it { should have_many(:birst_extract_groups).through(:birst_extract_group_collection_associations) }
end
