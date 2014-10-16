require 'rails_helper'

RSpec.describe TplBirstDuplicateSpace, :type => :model do
  before do
    @tpl = TplBirstDuplicateSpace.new(
      from_space_id_str: "1e3154e8-a1a3-4794-ae74-7a75c7f8041f",
      to_space_name: "some_new_space"
    )
  end

  subject { @tpl }

  it { should respond_to(:from_space_id_str) }
  it { should respond_to(:to_space_name) }
  it { should respond_to(:with_membership) }
  it { should respond_to(:with_data) }
  it { should respond_to(:with_datastore) }

  it { should validate_presence_of(:from_space_id_str) }
  it { should validate_presence_of(:to_space_name) }

  it { should have_one(:job_spec) }

  it { should be_valid }

  it { should respond_to(:run_template) }

  describe "when space id is invalid" do
    before { @tpl.from_space_id_str = "This should not work" }
    it { should be_invalid }
  end

  include BirstSoapSupport

  describe "running birst duplicate space as a job", :birst_soap_mock => true do
    before do
      job_spec = FactoryGirl.build(:job_spec, :template_tpl_birst_duplicate_space)
      @job_template = job_spec.job_template
      @job_template.from_space_id_str = BirstSoapFixtures.space_id_1
      @launched_job = FactoryGirl.build(:launched_job, job_spec: job_spec)
      @launched_job.send(:initialize_job)

      Settings.birst_soap.wait.timeout = '5s'
      Settings.birst_soap.wait.every = '0.3s'
      Settings.birst_soap.rufus_freq = '0.1s'
    end

    after { Settings.reload! }

    let(:run_template) { @job_template.run_template }

    context "with default options" do

      it "completes successfully" do
        mock_login_and_out do 
          savon.expects(:create_new_space)
            .with(message: BirstSoapFixtures.create_new_space_request)
            .returns(BirstSoapFixtures.create_new_space_response)
        end

        mock_copy_space(options: (Amylase::BirstSoap::ALL_COPY_COMPONENTS).join(';'))
        mock_copy_space(options: "settings-membership")
        mock_copy_space(options: "settings-permissions")

        run_template
      end
    end

    context "without membership" do
      before { @job_template.with_membership = false }
      it "completes successfully" do
        mock_login_and_out do 
          savon.expects(:create_new_space)
            .with(message: BirstSoapFixtures.create_new_space_request)
            .returns(BirstSoapFixtures.create_new_space_response)
        end

        mock_copy_space(options: (Amylase::BirstSoap::ALL_COPY_COMPONENTS - ["settings-membership"]).join(';'))

        run_template
      end
    end

    context "without data or datastore" do
      before do
        @job_template.with_data = false
        @job_template.with_datastore = false
      end

      it "completes successfully" do
        mock_login_and_out do 
          savon.expects(:create_new_space)
            .with(message: BirstSoapFixtures.create_new_space_request)
            .returns(BirstSoapFixtures.create_new_space_response)
        end

        mock_copy_space(options: (Amylase::BirstSoap::ALL_COPY_COMPONENTS - ["data","datastore"]).join(';'))
        mock_copy_space(options: "settings-membership")
        mock_copy_space(options: "settings-permissions")

        run_template
      end
    end

  end

end
