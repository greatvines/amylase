# spec/features/job_spec_features_spec.rb

require 'rails_helper'

feature 'User creates a JobSpec', :js => true do

  before do
    Capybara.current_driver = :webkit
    visit new_job_spec_path
    fill_in 'Name', with: 'the_george_job'
    check 'Enabled'
    select 'TplBirstDuplicateSpace', from: 'Job template type'
    fill_in 'From space id str', with: SecureRandom.uuid
    fill_in 'To space name', with: 'george_II'
    check 'With data'
  end

  after { Capybara.use_default_driver }

  context 'with valid data' do
    scenario 'the creation was successful' do
      click_button 'Create Job spec'

      expect(page).to have_content 'Success! JobSpec created.'
      expect(page).to have_content 'the_george_job'
      expect(page).to have_content 'job_template_type: TplBirstDuplicateSpace'
    end
  end

  context 'with invalid data' do
    scenario 'the creation was unsuccessful' do
      fill_in 'From space id str', with: 'not a valid UUI'
      click_button 'Create Job spec'

      expect(page).to have_content 'Error! JobSpec not created'
      expect(page).to have_content 'space id must be a UUID'
    end
  end

  context 'filling out a different template' do
    scenario 'selecting a new template' do
      select 'TplBirstSoapGenericCommand', from: 'Job template type'
      fill_in 'Command', with: 'list_spaces'
      click_button 'Create Job spec'
    
      expect(page).to have_content 'Success! JobSpec created.'
    end

    scenario 'without selecting a new template' do
      expect { fill_in 'Command', with: 'list_spaces' }.to raise_error Capybara::ElementNotFound
    end
  end
end


feature 'User runs a JobSpec now', :js => true do
  before do
    Capybara.current_driver = :webkit
    @job_spec = FactoryGirl.create(:job_spec, :with_client_spaces)
  end

  after { Capybara.use_default_driver }
  
  context 'without the JobScheduler' do
    context 'from the JobSpec#show page' do
      scenario 'clicks the Run now link' do
        visit job_spec_path(@job_spec)
        click_link 'Run now'
        expect(page).to have_content 'Error! JobScheduler not running'
      end
    end

    context 'from the JobSpec#index page' do
      scenario 'clicks the Run now link' do
        visit job_specs_path
        within( find('tr', text: @job_spec.name) ) { click_link 'run_now' }
        expect(page).to have_content 'Error! JobScheduler not running'
      end
    end
  end

  context 'with the JobScheduler' do
    before { JobScheduler.new.start_scheduler }
    after { JobScheduler.find.destroy }

    context 'from the JobSpec#show page' do
      scenario 'clicks the Run now link' do
        visit job_spec_path(@job_spec)
        click_link 'Run now'
        page.document.synchronize do
          visit current_path
          expect(find('tr', text: @job_spec.name)).to have_content(/(running|success)/)
        end
      end
    end

    context 'from the JobSpec#index page' do
      scenario 'clicks the Run now link' do

        # First make sure that the job isn't already running
        visit launched_jobs_path
        expect(page).to have_no_selector('tr', text: @job_spec.name)

        # Now launch the job
        visit job_specs_path
        within( find('tr', text: @job_spec.name) ) { click_link 'run_now' }
        page.document.synchronize do
          visit current_path
          expect(find('tr', text: @job_spec.name)).to have_content(/(running|success)/)
        end

      end
    end
  end
end
