require 'rails_helper'

RSpec.describe GooddataProject, :type => :model do
  before { @gooddata_project = FactoryGirl.create(:gooddata_project) }
  subject { @gooddata_project }

  it { should respond_to(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }
  it { should respond_to(:project_uid) }
  it { should respond_to(:client) }
  it { should be_valid }

  it { should belong_to(:client) }

  it { should allow_value('fe2grfsh5vh25kwm69zd3nhzki1cecyc').for(:project_uid) }
  it { should_not allow_value('fe2grfsh5vh25k-m69zd3nhzki1cecyc').for(:project_uid) }
  it { should_not allow_value('fe2grfsh5vh25kzki1cecyc').for(:project_uid) }
  it { should_not allow_value('').for(:project_uid) }
  it { should_not allow_value(nil).for(:project_uid) }
end
