# spec/features/data_sources_features_spec.rb

require 'rails_helper'

feature "User creates a Data Source" do

  before do
    visit new_data_source_path
    fill_in 'Name', with: 'CSV-Time_Zone'
    fill_in 'Birst filename', with: 'CSV-Time_Zone.csv'
    select 'S3DataSource', from: 'Data source type'
    fill_in 'S3 path', with: 's3://my-bucket/CSV-Time_Zone.csv'

  end

  scenario 'with valid data' do
    click_button 'Create Data source'
    expect(page).to have_content 'Success! DataSource created'
  end

  scenario 'with invalid data' do
    fill_in 'S3 path', with: 'S3://my bucket/CSV-Time_Zone.csv'
    click_button 'Create Data source'

    expect(page).to have_content 'Error! DataSource not created'
    expect(page).to have_content 'S3 path Must be a valid s3 path'
  end
end
