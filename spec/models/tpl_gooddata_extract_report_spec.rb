require 'rails_helper'

RSpec.describe TplGooddataExtractReport, :type => :model do
  before { @tpl = FactoryGirl.create(:tpl_gooddata_extract_report) }
  subject { @tpl }

  it { should respond_to(:name) }
  it { should respond_to(:report_oid) }
  it { should respond_to(:destination_file_name) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:report_oid) }
  it { should validate_presence_of(:destination_file_name) }

  it { should be_valid }

  it { should belong_to(:tpl_gooddata_extract) }

end
