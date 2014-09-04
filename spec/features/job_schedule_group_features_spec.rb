# spec/features/job_schedule_group_features_spec.rb

require 'rails_helper'

feature "User creates a JobScheduleGroup", :js => true do

  before do
    Capybara.current_driver = :webkit
    visit new_job_schedule_group_path
    fill_in 'Name', with: 'radicular_job_schedule'
    click_link 'Add Job Schedule'

    # Finding dynamically created input fields is ugly
    all(:css, 'input').each do |f|
      match = f.path =~ /job_schedule_group_job_schedules_attributes_.*_schedule_time/
      f.set('* 1 * * * America/Los_Angeles') if match
    end
  end

  after { Capybara.use_default_driver }

  context "with valid data" do
    scenario "the creation was successful" do
      click_button 'Create Job schedule group'

      expect(page).to have_content 'Success! JobScheduleGroup created'
      expect(page).to have_content 'radicular_job_schedule'
    end
  end

  context "with invalid data" do
    scenario "the creation was unsuccessful" do
      all(:css, 'input').each do |f|
        match = f.path =~ /job_schedule_group_job_schedules_attributes_.*_schedule_time/
        f.set('* 1 * * America/Los_Angeles') if match
      end

      click_button 'Create Job schedule group'

      expect(page).to have_content 'Error! JobScheduleGroup not created'
      expect(page).to have_content 'Invalid time format'
    end
  end

  context "with multiple job schedules, one is invalid" do
    before do
      click_link 'Add Job Schedule'

      panel_idx = 0
      all(:css, 'input').each do |f|
        if f.path =~ /job_schedule_group_job_schedules_attributes_.*_schedule_time/
          panel_idx += 1
          f.set('* 1 * * America/Los_Angeles') if panel_idx == 1
          f.set('* 1 * * * America/Los_Angeles') if panel_idx == 2
        end
      end
    end

    scenario "the submitted form is invalid" do
      click_button 'Create Job schedule group'
      expect(page).to have_content 'Error! JobScheduleGroup not created'
      expect(page).to have_content 'Invalid time format'
    end

    scenario "the invalid job schedule is deleted before submitting" do
      first(:css, 'a', :text => 'Remove Job Schedule').click
      click_button 'Create Job schedule group'
      expect(page).to have_content 'Success! JobScheduleGroup created'
    end
  end
end
