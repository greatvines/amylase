require 'rails_helper'

RSpec.describe BirstProcessGroupCollection, :type => :model do
  before { @birst_process_group_collection = FactoryGirl.create(:birst_process_group_collection) }
  subject { @birst_process_group_collection }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should be_valid }

  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }

  it { should have_many(:birst_process_group_collection_associations).dependent(:destroy) }
  it { should have_many(:birst_process_groups).through(:birst_process_group_collection_associations) }
end
