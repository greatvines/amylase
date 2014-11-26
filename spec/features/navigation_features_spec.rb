# spec/features/navigation_features_spec.rb

require 'rails_helper'

feature 'User navigates across the site' do
  include ApplicationHelper

  def have_full_title(title)
    have_title /\A#{Regexp.escape(full_title(title))}\Z/
  end
  
  # expect all create/view links to take them to the right page (including admin)
  before do
    visit root_path
  end

  scenario 'the root path' do
    expect(page).to have_full_title 'Job Summary'

    expect(page).to have_link 'new_job_spec'
    expect(page).to have_link 'new_job_schedule_group'
    expect(page).to have_link 'new_client'
    expect(page).to have_link 'new_birst_space'
    expect(page).to have_link 'new_data_source'
    expect(page).to have_link 'new_data_source_collection'
    expect(page).to have_link 'new_birst_process_group'
    expect(page).to have_link 'new_birst_process_group_collection'
    expect(page).to have_link 'new_birst_extract_group'
    expect(page).to have_link 'new_birst_extract_group_collection'

    expect(page).to have_link 'job_specs'
    expect(page).to have_link 'job_schedule_groups'
    expect(page).to have_link 'clients'
    expect(page).to have_link 'birst_spaces'
    expect(page).to have_link 'data_sources'
    expect(page).to have_link 'data_source_collections'
    expect(page).to have_link 'birst_process_groups'
    expect(page).to have_link 'birst_process_group_collections'
    expect(page).to have_link 'birst_extract_groups'
    expect(page).to have_link 'birst_extract_group_collections'

    expect(page).to have_link 'new_job_scheduler'
    expect(page).not_to have_link 'job_scheduler'
    expect(page).not_to have_link 'destroy_job_scheduler'
  end

  scenario 'the new_job_spec path' do
    click_link 'new_job_spec'
    expect(page).to have_full_title 'New Job Spec'
  end

  scenario 'the new_job_schedule_group path' do
    click_link 'new_job_schedule_group'
    expect(page).to have_full_title 'New Job Schedule Group'
  end

  scenario 'the new_client path' do
    click_link 'new_client'
    expect(page).to have_full_title 'New Client'
  end

  scenario 'the new_birst_space path' do
    click_link 'new_birst_space'
    expect(page).to have_full_title 'New Birst Space'
  end

  scenario 'the new_data_source path' do
    click_link 'new_data_source'
    expect(page).to have_full_title 'New Data Source'
  end

  scenario 'the new_data_source_collection path' do
    click_link 'new_data_source_collection'
    expect(page).to have_full_title 'New Data Source Collection'
  end

  scenario 'the new_birst_process_group path' do
    click_link 'new_birst_process_group'
    expect(page).to have_full_title 'New Birst Process Group'
  end

  scenario 'the new_birst_process_group_collection path' do
    click_link 'new_birst_process_group_collection'
    expect(page).to have_full_title 'New Birst Process Group Collection'
  end

  scenario 'the new_birst_extract_group path' do
    click_link 'new_birst_extract_group'
    expect(page).to have_full_title 'New Birst Extract Group'
  end

  scenario 'the new_birst_extract_group_collection path' do
    click_link 'new_birst_extract_group_collection'
    expect(page).to have_full_title 'New Birst Extract Group Collection'
  end

  scenario 'the launched_jobs path' do
    click_link 'launched_jobs'
    expect(page).to have_full_title 'Job Summary'
  end

  scenario 'the job_specs path' do
    click_link 'job_specs'
    expect(page).to have_full_title 'Job Specs'
  end

  scenario 'the job_schedule_groups path' do
    click_link 'job_schedule_groups'
    expect(page).to have_full_title 'Job Schedules'
  end

  scenario 'the clients path' do
    click_link 'clients'
    expect(page).to have_full_title 'Clients'
  end

  scenario 'the birst_spaces path' do
    click_link 'birst_spaces'
    expect(page).to have_full_title 'Birst Spaces'
  end

  scenario 'the data_sources path' do
    click_link 'data_sources'
    expect(page).to have_full_title 'Data Sources'
  end

  scenario 'the data_source_collections path' do
    click_link 'data_source_collections'
    expect(page).to have_full_title 'Data Source Collections'
  end

  scenario 'the birst_process_groups path' do
    click_link 'birst_process_groups'
    expect(page).to have_full_title 'Birst Process Groups'
  end

  scenario 'the birst_process_group_collections path' do
    click_link 'birst_process_group_collections'
    expect(page).to have_full_title 'Birst Process Group Collections'
  end

  scenario 'the birst_extract_groups path' do
    click_link 'birst_extract_groups'
    expect(page).to have_full_title 'Birst Extract Groups'
  end

  scenario 'the birst_extract_group_collections path' do
    click_link 'birst_extract_group_collections'
    expect(page).to have_full_title 'Birst Extract Group Collections'
  end


  scenario 'the new_job_scheduler path' do
    click_link 'new_job_scheduler'
    expect(page).to have_full_title 'New Job Scheduler'
  end

  context 'with a job scheduler running' do
    before { JobScheduler.new.start_scheduler }
    after { JobScheduler.find.destroy if JobScheduler.find }

    scenario 'the job_scheduler_path' do
      click_link 'job_scheduler'
      expect(page).to have_full_title 'Job Scheduler'
    end

    scenario 'destroying the job_scheduler' do
      visit root_path
      expect(page).not_to have_content "Job scheduler not running!"
      
      click_link 'destroy_job_scheduler'
      expect(page).to have_content "Job scheduler not running!"
    end
  end
end
