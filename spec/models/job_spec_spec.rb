require 'rails_helper'

RSpec.describe JobSpec, :type => :model do

  before { @job_spec = FactoryGirl.create(:job_spec) }
  subject { @job_spec }

  it "should do something" do
    puts @job_spec.inspect
    puts @job_spec.job_template.inspect
  end

  it { should respond_to(:name) }
  it { should respond_to(:enabled) }
  it { should respond_to(:job_template) }

  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }

  context "using a copy to get around ensure_inclusion_of bug" do
    before { @job_spec_dup = @job_spec.dup }
    subject { @job_spec_dup }

    it { should ensure_inclusion_of(:job_template_type).in_array(JobSpec::JOB_TEMPLATE_TYPES) }
  end

  it { should belong_to(:job_template) }
  it { should accept_nested_attributes_for(:job_template) }
  
  it { should be_valid }


  describe "default values" do
    specify "enabled has correct default" do
      expect(@job_spec.enabled).to eq false
    end
  end

  it "should fail when name already exists" do
    expect(@job_spec.dup).not_to be_valid
  end

  describe "associated JobTemplate" do
    let(:job_template_id) { @job_spec.job_template.id }

    it "exists when the JobSpec is created" do
      expect(job_template_id).not_to be_nil
    end

    it "is destroyed when the JobSpec is destroyed" do
      expect { @job_spec.destroy }
        .to change(@job_spec.job_template_type.constantize, :count).by(-1) 
    end
  end

end
