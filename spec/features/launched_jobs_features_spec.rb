# spec/features/job_spec_features_spec.rb

require 'rails_helper'

feature "User interacts with the launched job summary page", :js => true do

  before do

    @clients = []

    FactoryGirl.create_list(:client, 2).each do |client|
      @clients << client

      job_spec = FactoryGirl.create(:job_spec, client: client)
      FactoryGirl.create(:launched_job, job_spec: job_spec, 
        status: LaunchedJob::RUNNING, 
        start_time: Time.now - Random.rand(2.hours)
      )

      start_time = Time.now - 5.hours + Random.rand(1.hour)
      FactoryGirl.create(:launched_job, job_spec: job_spec, 
        status: LaunchedJob::ERROR, 
        start_time: start_time,
        end_time: start_time + Random.rand(1.hour)
      )

      start_time = Time.now - 5.hours + Random.rand(1.hour) 
      FactoryGirl.create(:launched_job, job_spec: job_spec, 
        status: LaunchedJob::SUCCESS, 
        start_time: start_time,
        end_time: start_time + Random.rand(1.hour)
      )
    end
    

    Capybara.current_driver = :webkit
    visit launched_jobs_path
  end

  after { Capybara.use_default_driver }

  scenario "searching through the launched jobs" do
    expect(page).to have_content @clients[0].name
    expect(page).to have_content @clients[1].name
    expect(page).to have_content 'error'
    expect(page).to have_content 'running'
    expect(page).to have_content 'success'

    # Yes, the columns are hard-coded.  Will need to revisit this whole mess
    fill_in 'input_search_0', with: @clients[1].name
    sleep 0.5 # give the page a moment to refresh
    expect(page).to_not have_content @clients[0].name

    fill_in 'input_search_0', with: ''
    sleep 0.5 # give the page a moment to refresh
    expect(page).to have_content @clients[0].name

    fill_in 'input_search_5', with: 'ror'
    sleep 0.5 # give the page a moment to refresh
    expect(page).to_not have_content 'success'

    fill_in 'input_search_5', with: ''
    sleep 0.5 # give the page a moment to refresh
    expect(page).to have_content 'success'

    fill_in 'input_min_start_date', with: (Time.now + 1.day).strftime("%Y-%m-%d")
    page.execute_script("$('#input_min_start_date').blur()")
    sleep 1
    expect(page).to_not have_content @clients[0].name
    expect(page).to_not have_content @clients[1].name

    fill_in 'input_min_start_date', with: (Time.now - 1.day).strftime("%Y-%m-%d")
    page.execute_script("$('#input_min_start_date').blur()")
    sleep 1
    expect(page).to have_content @clients[0].name
    expect(page).to have_content @clients[1].name

  end
end
