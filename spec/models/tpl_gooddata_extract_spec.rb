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

  it 'accepts nested attributes for repots via a jobspec' do
    params = {
      name: 'DummyJobSpec',
      job_template_type: 'TplGooddataExtract',
      job_template_attributes: {
        gooddata_project_id: 1,
        destination_path: 'ftp://example.com/reports.zip',
        tpl_gooddata_extract_reports_attributes: {
          one: {
            name: 'depletions',
            report_oid: '12345',
            destination_file_name: 'depletions.csv',
          },
          two: {
            name: 'sales',
            report_oid: '98765',
            destination_file_name: 'sales.csv',
          }
        }
      }
    }

    JobSpec.create(params)
    job_spec = JobSpec.where(name: 'DummyJobSpec').take

    expect(job_spec.job_template.tpl_gooddata_extract_reports.size).to eq 2

    rpt_names = job_spec.job_template.tpl_gooddata_extract_reports.collect { |rpt| rpt.name }
    expect(rpt_names).to match_array ['sales', 'depletions']
  end

end
