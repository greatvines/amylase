require 'rails_helper'

RSpec.describe ExternalCredential, :type => :model do
  before { @external_credential = FactoryGirl.build(:external_credential) }
  subject { @external_credential }

  it { should respond_to(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:username) }
  it { should respond_to(:password) }
  it { should be_valid }

  it 'does not store the plain text password in memory' do
    expect(@external_credential.password).not_to eq @external_credential.read_attribute(:password)
  end

  it 'stores the encrypted password' do
    expect(Envcrypt::Envcrypter.new.encrypt(@external_credential.password)).to eq @external_credential.read_attribute(:password)
  end

  it 'can save the credential even when the password is blank' do
    expect { FactoryGirl.build(:external_credential, password: '') }.to_not raise_error
  end
end
