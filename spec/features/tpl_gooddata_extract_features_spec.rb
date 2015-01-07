# spec/features/tpl_gooddata_extract_features_spec.rb

require 'rails_helper'

feature 'User creates a TplGooddataExtract', :js => true do

  # Helper to match one fo the extract report parameters on the form
  def report_attribute_matcher(attribute)
    /job_spec_job_template_attributes_tpl_gooddata_extract_reports_attributes_[0-9]+_#{attribute}/
  end

  # Helper to fill an extract report parameter subform.  See below for examples.
  def fill_reports(form_element, name: nil, report_oid: nil, destination_file_name: nil)
    case
    when form_element.path =~ report_attribute_matcher('name')
      form_element.set(Array(name).shift)
    when form_element.path =~ report_attribute_matcher('report_oid')
      form_element.set(Array(report_oid).shift)
    when form_element.path =~ report_attribute_matcher('destination_file_name')
      form_element.set(Array(destination_file_name).shift)
    end
  end


  before do
    Capybara.current_driver = :webkit

    @gooddata_project = FactoryGirl.create(:gooddata_project)

    visit new_job_spec_path
    fill_in 'Name', with: 'feature_gooddata_extract'
    check 'Enabled'
    select 'TplGooddataExtract', from: 'Job template type'

    select @gooddata_project.name, from: 'Gooddata project'
    fill_in 'Destination path', with: 'ftp://example.com/feature_reports.csv'
  end

  after { Capybara.use_default_driver }

  context 'with valid data' do
    scenario 'the creation was successful' do
      click_link 'Add Gooddata Report'
      all(:css, 'input').each do |f|
        fill_reports(f, name: 'first_report', report_oid: '12345', destination_file_name: 'first_report.csv')
      end

      click_button 'Create Job spec'

      expect(page).to have_content 'Success! JobSpec created.'
      expect(page).to have_content 'job_template_type: TplGooddataExtract'

      # It create the report objects
      job_spec = JobSpec.where(name: 'feature_gooddata_extract').take
      expect(job_spec.job_template.tpl_gooddata_extract_reports.first.name).to eq 'first_report'
    end
  end

  context 'with invalid data' do
    scenario 'the creation was unsuccessful' do
      click_link 'Add Gooddata Report'
      all(:css, 'input').each do |f|
        fill_reports(f, name: 'first_report', report_oid: '', destination_file_name: 'first_report.csv')
      end
      click_button 'Create Job spec'

      expect(page).to have_content 'Error! JobSpec not created'
      expect(page).to have_content 'report oid can\'t be blank'
    end
  end

  context 'with multiple extract reports' do
    scenario 'all reports are valid' do
      click_link 'Add Gooddata Report'
      click_link 'Add Gooddata Report'

      reports_params = {
        name: ['first_report', 'second_report'],
        report_oid: ['12345', '67890'],
        destination_file_name: ['first_report.csv', 'second_report.csv']
      }

      all(:css, 'input').each do |f|
        fill_reports(f, reports_params)
      end
      click_button 'Create Job spec'

      expect(page).to have_content 'Success! JobSpec created.'

      # It created the report objects
      job_spec = JobSpec.where(name: 'feature_gooddata_extract').take
      rpt_names = job_spec.job_template.tpl_gooddata_extract_reports.collect { |rpt| rpt.name }
      expect(rpt_names).to match_array ['first_report', 'second_report']

    end
  end
end
