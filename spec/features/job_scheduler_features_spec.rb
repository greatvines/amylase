# spec/features/job_scheduler_features_spec.rb

require 'rails_helper'

feature "User creates the scheduler" do

  before do
    visit job_scheduler_path
    click_link 'New Job scheduler'
    
    fill_in 'Timeout', with: '1'
    click_button 'Create Job scheduler'
  end

  scenario "scheduler is created successfully and destroyed successfully" do

    expect(page).to have_content 'Success! JobScheduler created.'
    expect(page).to have_content 'Running: true'

    click_link 'Destroy'
    expect(page).to have_content 'Success! JobScheduler destroyed.'
  end

  scenario "scheduler times out" do
    expect(page).to have_content 'Running: true'

    sleep(1.5)
    visit job_scheduler_path
    expect(page).to have_content 'Running: false'
  end
end
