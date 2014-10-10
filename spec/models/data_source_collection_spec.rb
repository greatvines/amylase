require 'rails_helper'

RSpec.describe DataSourceCollection, :type => :model do
  before { @data_source_collection = FactoryGirl.create(:data_source_collection) }
  subject { @data_source_collection }

  it { should respond_to(:name) }
  it { should be_valid }

  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }

  it { should have_many(:data_source_collection_associations).dependent(:destroy) }
  it { should have_many(:data_sources).through(:data_source_collection_associations) }

  it { should accept_nested_attributes_for(:data_source_collection_associations) }
end
