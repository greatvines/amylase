# spec/features/birst_extract_groups_features_spec.rb

require 'rails_helper'

feature "User creates a BirstExtractGroup" do

  before do
    visit new_birst_extract_group_path
    fill_in 'Name', with: 'SomeExtractGroup'
    fill_in 'Description', with: 'An awesome one'
  end

  scenario 'with valid data' do
    click_button 'Create Birst extract group'
    expect(page).to have_content 'Success! BirstExtractGroup created'
  end

  scenario 'with invalid data' do
    fill_in 'Name', with: ''
    click_button 'Create Birst extract group'

    expect(page).to have_content 'Error! BirstExtractGroup not created'
    expect(page).to have_content "Name can't be blank"
  end
end
