# spec/features/birst_process_group_collections_features_spec.rb

require 'rails_helper'

feature "User creates a BirstProcessGroupCollection" do

  before do
    # Populate with some process groups
    birst_process_groups = FactoryGirl.create_list(:birst_process_group, 3)

    # Choose some process_groups to select
    selected_process_groups = birst_process_groups[0..1]

    visit new_birst_process_group_collection_path
    fill_in 'Name', with: 'A BirstProcessGroupCollection'

    selected_process_groups.each do |ds|
      find(:css, "#birst_process_group_collection_birst_process_group_ids_#{ds.id}").set(true)
    end
  end

  scenario 'with valid data' do
    click_button 'Create Birst process group collection'

    expect(page).to have_content 'Success! BirstProcessGroupCollection created'
    expect(page).to have_xpath "//span[@class='glyphicon glyphicon-ok']", count: 2
    expect(page).to have_xpath "//span[@class='glyphicon glyphicon-minus']", count: 1
  end

  scenario 'with invalid data' do
    fill_in 'Name', with: ''
    click_button 'Create Birst process group collection'

    expect(page).to have_content 'Error! BirstProcessGroupCollection not created'
    expect(page).to have_content "Name can't be blank"
  end
end
