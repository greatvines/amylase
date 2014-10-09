# spec/features/data_source_groups_features_spec.rb

require 'rails_helper'

feature "User creates a DataSourceGroup" do

  before do
    # Populate with some data souces
    data_sources = FactoryGirl.create_list(:data_source, 3)

    # Choose some data sources to select
    selected_data_sources = data_sources[0..1]

    visit new_data_source_group_path
    fill_in 'Name', with: 'A DataSourceGroup'

    selected_data_sources.each do |ds|
      find(:css, "#data_source_group_data_source_ids_#{ds.id}").set(true)
    end
  end

  scenario 'with valid data' do
    click_button 'Create Data source group'

    expect(page).to have_content 'Success! DataSourceGroup created'
    expect(page).to have_xpath "//span[@class='glyphicon glyphicon-ok']", count: 2
    expect(page).to have_xpath "//span[@class='glyphicon glyphicon-minus']", count: 1
  end

  scenario 'with invalid data' do
    fill_in 'Name', with: ''
    click_button 'Create Data source group'

    expect(page).to have_content 'Error! DataSourceGroup not created'
    expect(page).to have_content "Name can't be blank"
  end
end
