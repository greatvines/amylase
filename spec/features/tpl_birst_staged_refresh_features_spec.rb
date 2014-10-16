# spec/features/tpl_birst_staged_refresh_features_spec.rb

require 'rails_helper'

feature "User creates a TplBirstStagedRefresh", :js => true do

  before do
    @selected_client = FactoryGirl.create_list(:client, 3)[1]
    @production_space = FactoryGirl.create(:birst_space, space_type: 'production', client: @selected_client)
    @other_space = FactoryGirl.create(:birst_space, space_type: 'other', client: @selected_client)

    @selected_data_collection = FactoryGirl.create_list(:data_source_collection, 3)[2]

    Capybara.current_driver = :webkit
    visit new_job_spec_path
    fill_in 'Name', with: 'my_staged_refresh'
    check 'Enabled'
    select @selected_client.name, from: 'Client'
    select 'TplBirstStagedRefresh', from: 'Job template type'

    select @other_space.name, from: 'Staging space'
    select @selected_data_collection.name, from: 'Data source collection'

  end

  after { Capybara.use_default_driver }

  context "with valid data" do
    scenario "the creation was successful" do
      click_button 'Create Job spec'

      expect(page).to have_content 'Success! JobSpec created.'
      expect(page).to have_content 'job_template_type: TplBirstStagedRefresh'
      expect(page).to have_content "staging_space_id: #{@other_space.id}"
      expect(page).to have_content "client_id: #{@selected_client.id}"
    end
  end
end
