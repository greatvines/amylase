require 'rails_helper'

RSpec.describe ExternalCredential, :type => :model do
  before { @external_credential = FactoryGirl.create(:external_credential) }
  subject { @external_credential }

  it { should respond_to(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:username) }
  it { should respond_to(:password) }
  it { should be_valid }

  # Do some stuff here with valiating whether the password is encrypted


end
