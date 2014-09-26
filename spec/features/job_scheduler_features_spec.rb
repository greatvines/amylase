# spec/features/job_scheduler_features_spec.rb

require 'rails_helper'

feature "Alert if the scheduler is not running" do
  scenario "Visiting pages should show alert that scheduler is not running" do
    visit root_path
    expect(page).to have_content "Job scheduler not running!"

    visit job_specs_path
    expect(page).to have_content "Job scheduler not running!"
  end
end

feature "User creates the scheduler" do

  before do
    @job_spec = FactoryGirl.create :job_spec, :template_tpl_dev_test, :schedule_in_1s, enabled: true

    visit job_scheduler_path
    click_link 'New Job scheduler'
    
    fill_in 'Timeout', with: '2'
    click_button 'Create Job scheduler'
  end

  scenario "scheduler is created, runs a job, destroyed successfully" do

    expect(page).to have_content 'Success! JobScheduler created.'
    expect(page).to have_content 'Running: true'
    expect(page).not_to have_content "Job scheduler not running!"

    sleep(1.5)
    expect(LaunchedJob.find_by(job_spec: @job_spec).status).to eq LaunchedJob::SUCCESS

    click_link 'Destroy'
    expect(page).to have_content 'Success! JobScheduler destroyed.'
    expect(page).to have_content "Job scheduler not running!"
  end

  scenario "scheduler times out" do
    expect(page).to have_content 'Running: true'

    sleep(2.5)
    visit job_scheduler_path
    expect(page).to have_content 'Running: false'
    expect(page).to have_content "Job scheduler not running!"

    click_link 'Destroy'
  end
end
