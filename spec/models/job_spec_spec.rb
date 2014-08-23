require 'rails_helper'

RSpec.describe JobSpec, :type => :model do
  before do
    @job_spec = JobSpec.new(
      name:    "a_fascinating_job",
      job_template_type: "TplBirstSoapGenericCommand",
      job_template_attributes: {
        command: "list_spaces"
      }
    )
  end

  subject { @job_spec }

  it { should respond_to(:name) }
  it { should respond_to(:enabled) }
  it { should respond_to(:job_template) }

  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }
  it { should ensure_inclusion_of(:job_template_type).in_array(JobSpec::JOB_TEMPLATE_TYPES) }

  it { should belong_to(:job_template) }
  
  it { should be_valid }



  describe "default values" do
    specify { expect(@job_spec.enabled).to eq false }
  end

  describe "when name already exists" do
    before do
      job_spec_dup = @job_spec.dup
      job_spec_dup.save
      @job_spec.save
    end

    it { should_not be_valid }
  end

  describe "job_template associations" do
    before { @job_spec.save }
    let(:job_template_id) { @job_spec.job_template.id }

    describe "existence of job_template" do
      specify { expect(job_template_id).not_to be_nil }
    end

    describe "destroying a job_spec" do
      specify {
        expect { @job_spec.destroy }
          .to change(@job_spec.job_template_type.constantize, :count).by(-1) 
      }
    end
  end
end
