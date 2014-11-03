# spec/features/job_spec_features_spec.rb

require 'rails_helper'

feature 'User interacts with the launched job summary page', :js => true do
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

  scenario 'searching through the launched jobs' do
    expect(page).to have_content @clients[0].name
    expect(page).to have_content @clients[1].name
    expect(page).to have_content 'error'
    expect(page).to have_content 'running'
    expect(page).to have_content 'success'

    # Yes, the columns are hard-coded.  Would like to revisit this whole mess
    fill_in 'input_search_1', with: @clients[1].name
    expect(page).to_not have_content @clients[0].name

    fill_in 'input_search_1', with: ''
    expect(page).to have_content @clients[0].name

    fill_in 'input_search_6', with: 'ror'
    expect(page).to_not have_content 'success'

    fill_in 'input_search_6', with: ''
    expect(page).to have_content 'success'

    fill_in 'input_min_start_date', with: (Time.now + 1.day).strftime('%Y-%m-%d')
    page.execute_script("$('#input_min_start_date').blur()")
    expect(page).to_not have_content @clients[0].name
    expect(page).to_not have_content @clients[1].name

    fill_in 'input_min_start_date', with: (Time.now - 1.day).strftime('%Y-%m-%d')
    page.execute_script("$('#input_min_start_date').blur()")
    expect(page).to have_content @clients[0].name
    expect(page).to have_content @clients[1].name
  end

  feature 'rerunning a job' do
    before do
      @launched_job = FactoryGirl.create(:launched_job, :with_tpl_dev_test_job_spec,
        status: LaunchedJob::ERROR, 
        start_time: Time.now - 1.minute,
        end_time: Time.now - 30.seconds
      )
    end
    
    context 'without the JobScheduler' do
      scenario 'clicks the Rerun job link' do
        visit launched_jobs_path
        within( find('tr', text: @launched_job.job_spec.name) ) { click_link 'run_now' }
        expect(page).to have_content 'Error! JobScheduler not running'
      end
    end

    context 'with the JobScheduler' do
      before { JobScheduler.new.start_scheduler }
      after { JobScheduler.find.destroy }

      scenario 'clicks the Rerun job link' do
        visit launched_jobs_path
        within( find('tr', text: @launched_job.job_spec.name) ) { click_link 'run_now' }
        page.document.synchronize do
          visit current_path
          expect(find("tr#id#{LaunchedJob.last.id}")).to have_content(/(running|success)/)
        end
      end
    end
  end


  feature 'killing a job' do
    before do
      @launched_job = FactoryGirl.create(:launched_job, :with_tpl_dev_test_job_spec,
        status: LaunchedJob::RUNNING, 
        start_time: Time.now - 1.minute
      )
    end

    scenario 'user clicks the kill job link' do
      visit launched_jobs_path
      expect(find("tr#id#{@launched_job.id}")).to have_content(/running/)
      
      within( find("tr#id#{@launched_job.id}") ) { click_link 'kill_job' }
      page.document.synchronize do
        visit current_path
        expect(find("tr#id#{@launched_job.id}")).to have_content(/error/)
      end
    end
  end
end
