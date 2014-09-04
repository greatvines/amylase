# spec/features/job_spec_features_spec.rb

require 'rails_helper'

feature "User creates a JobSpec" do

  before do
    visit new_job_spec_path
    fill_in 'Name', with: 'the_george_job'
    check 'Enabled'
    select 'TplBirstDuplicateSpace', from: 'Job template type'
    fill_in 'From space id str', with: SecureRandom.uuid
    fill_in 'To space name', with: 'george_II'
    check 'With data'
  end

  context "with valid data" do
    scenario "the creation was successful" do
      click_button 'Create Job spec'

      expect(page).to have_content 'Success! JobSpec created.'
      expect(page).to have_content 'the_george_job'
      expect(page).to have_content 'job_template_type: TplBirstDuplicateSpace'
    end
  end

  context "with invalid data" do
    scenario "the creation was unsuccessful" do
      fill_in 'From space id str', with: 'not a valid UUI'
      click_button 'Create Job spec'

      expect(page).to have_content 'Error! JobSpec not created'
      expect(page).to have_content 'space id must be a UUID'
    end
  end
end
