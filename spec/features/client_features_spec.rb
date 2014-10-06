# spec/features/client_features_spec.rb

require 'rails_helper'

feature "User creates a Client" do

  before do
    visit new_client_path
    fill_in 'Name', with: 'some_client'
    fill_in 'Redshift schema', with: 'some_schema'

    click_button 'Create Client'
  end

  scenario 'client is created' do
    expect(page).to have_content 'Success! Client created'
  end

  scenario 'user attempts to create a duplicate client' do
    visit new_client_path
    fill_in 'Name', with: 'some_client'
    fill_in 'Redshift schema', with: 'some_schema'

    click_button 'Create Client'

    expect(page).to have_content 'Error! Client not created'
    expect(page).to have_content 'Name has already been taken'
  end
end
