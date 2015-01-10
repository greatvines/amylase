# spec/features/external_credentials_features_spec.rb

require 'rails_helper'

feature 'User creates an ExternalCredential' do

  before do
    visit new_external_credential_path
    fill_in :external_credential_name, with: 'Curious'
    fill_in :external_credential_username, with: 'George'
    fill_in :external_credential_password, with: 'YellowHat'
  end

  context 'with valid parameters' do
    scenario 'external_credential is created' do
      click_button :submit_external_credential
      expect(page).to have_content 'Success! ExternalCredential created'

      # Stores the encrypted password
      expect(ExternalCredential.where(name: 'Curious').take.read_attribute(:password)).to eq Envcrypt::Envcrypter.new.encrypt('YellowHat')
    end
  end

  context 'with invalid parameters' do
    before { fill_in :external_credential_name, with: '' }
    
    scenario 'external_credential is not created' do
      click_button :submit_external_credential
      expect(page).to have_content 'Error! ExternalCredential not created'
    end
  end
end
