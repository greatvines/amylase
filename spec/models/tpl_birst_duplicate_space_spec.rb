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

  describe "when space id is invalid" do
    before { @tpl.from_space_id_str = "This should not work" }
    it { should be_invalid }
  end
end
