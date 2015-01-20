# spec/features/gooddata_projects_features_spec.rb

require 'rails_helper'

feature "User creates a Gooddata Project" do

  before do
    FactoryGirl.create(:client, name: 'FeatureTestClient')

    visit new_gooddata_project_path
    fill_in 'Name', with: 'some_project'
    select 'FeatureTestClient', from: 'Client'
    fill_in 'Project uid', with: 'abcdef5sdoudfmm123yllz0mabciy5v3'

  end

  scenario 'gooddata project is created' do
    click_button 'Create Gooddata project'
    expect(page).to have_content 'Success! GooddataProject created'
  end

  scenario 'with invalid data' do
    fill_in 'Project uid', with: 'bad-uuid'
    click_button 'Create Gooddata project'

    expect(page).to have_content 'Error! GooddataProject not created'
    expect(page).to have_content 'Gooddata project ids are 32 characters long'
  end
end
