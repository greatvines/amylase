# spec/features/birst_spaces_features_spec.rb

require 'rails_helper'

feature "User creates a Birst Space" do

  before do
    FactoryGirl.create(:client, name: 'FeatureTestClient')

    visit new_birst_space_path
    fill_in 'Name', with: 'some_birst_space'
    select 'FeatureTestClient', from: 'Client'
    select 'production', from: 'Space type'
    fill_in 'Space uuid', with: '5efddbea-3481-46fd-b7c1-4e04046cefb7'

  end

  scenario 'birst space is created' do
    click_button 'Create Birst space'
    expect(page).to have_content 'Success! BirstSpace created'
  end

  scenario 'with invalid data' do
    fill_in 'Space uuid', with: 'bad-uuid'
    click_button 'Create Birst space'

    expect(page).to have_content 'Error! BirstSpace not created'
    expect(page).to have_content 'must be a valid UUID'
  end
end
