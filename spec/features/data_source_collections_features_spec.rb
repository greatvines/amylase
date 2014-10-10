# spec/features/data_source_collections_features_spec.rb

require 'rails_helper'

feature "User creates a DataSourceCollection" do

  before do
    # Populate with some data souces
    data_sources = FactoryGirl.create_list(:data_source, 3)

    # Choose some data sources to select
    selected_data_sources = data_sources[0..1]

    visit new_data_source_collection_path
    fill_in 'Name', with: 'A DataSourceCollection'

    selected_data_sources.each do |ds|
      find(:css, "#data_source_collection_data_source_ids_#{ds.id}").set(true)
    end
  end

  scenario 'with valid data' do
    click_button 'Create Data source collection'

    expect(page).to have_content 'Success! DataSourceCollection created'
    expect(page).to have_xpath "//span[@class='glyphicon glyphicon-ok']", count: 2
    expect(page).to have_xpath "//span[@class='glyphicon glyphicon-minus']", count: 1
  end

  scenario 'with invalid data' do
    fill_in 'Name', with: ''
    click_button 'Create Data source collection'

    expect(page).to have_content 'Error! DataSourceCollection not created'
    expect(page).to have_content "Name can't be blank"
  end
end
