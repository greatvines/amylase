# spec/features/birst_process_groups_features_spec.rb

require 'rails_helper'

feature "User creates a BirstProcessGroup" do

  before do
    visit new_birst_process_group_path
    fill_in 'Name', with: 'SomeProcessGroup'
    fill_in 'Description', with: 'An awesome one'
  end

  scenario 'with valid data' do
    click_button 'Create Birst process group'
    expect(page).to have_content 'Success! BirstProcessGroup created'
  end

  scenario 'with invalid data' do
    fill_in 'Name', with: ''
    click_button 'Create Birst process group'

    expect(page).to have_content 'Error! BirstProcessGroup not created'
    expect(page).to have_content "Name can't be blank"
  end
end
