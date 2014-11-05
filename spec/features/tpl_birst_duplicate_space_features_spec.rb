# spec/features/tpl_birst_duplicate_space_features_spec.rb

require 'rails_helper'

feature 'user interacts with the TplBirstDuplicateSpace JobSpec form', :js => true do
  before { Capybara.current_driver = :webkit }
  after { Capybara.use_default_driver }

  feature 'to create a new TplBirstDuplicateSpace job' do
    before do
      visit new_job_spec_path
      fill_in 'Name', with: 'the_george_job'
      check 'Enabled'
      select 'TplBirstDuplicateSpace', from: 'Job template type'
      fill_in 'From space id str', with: SecureRandom.uuid
      fill_in 'To space name', with: 'george_II'
      check 'With data'
    end

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
  end

  feature 'to edit an existing TplBirstDuplicateSpace job' do
    before do
      @tpl = FactoryGirl.create(:tpl_birst_duplicate_space, with_membership: false, with_data: true)
      @job_spec = FactoryGirl.create(:job_spec, job_template: @tpl)

      visit edit_job_spec_path @job_spec
    end

    scenario 'unchecking an option' do
      expect(@job_spec.job_template.with_data).to be true

      uncheck 'With data'
      click_button 'Update Job spec'

      expect(page).to have_content 'Success! JobSpec updated'
      
      @job_spec.reload
      expect(@job_spec.job_template_id).to eq @tpl.id
      expect(@job_spec.job_template.with_data).to be false
    end
    
  end
end


