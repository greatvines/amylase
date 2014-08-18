require 'rails_helper'

RSpec.describe TplBirstSoapGenericCommand, :type => :model do
  before do
    @tpl = TplBirstSoapGenericCommand.new(
      command:       "list_spaces",
      argument_json: ""
    )
  end

  subject { @tpl }

  it { should respond_to(:command) }
  it { should respond_to(:argument_json) }
  
  it { should validate_presence_of(:command) }

  it { should have_one(:job_spec) }

  it { should be_valid }
end
