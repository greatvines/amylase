require 'rails_helper'

RSpec.describe TplGooddataExtract, :type => :model do
  before { @tpl = FactoryGirl.create(:tpl_gooddata_extract) }
  subject { @tpl }

  it { should respond_to(:destination_path) }
  it { should be_valid }

  it { should belong_to(:gooddata_project) }
  it { should belong_to(:destination_credential).class_name('ExternalCredential') }
  it { should have_one(:job_spec) }

  it { should have_one(:client).through(:job_spec) }

  it { should have_many(:tpl_gooddata_extract_reports).dependent(:destroy) }
  it { should accept_nested_attributes_for(:tpl_gooddata_extract_reports) }
end
