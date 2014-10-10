# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tpl_birst_staged_refresh do
    data_source_collection nil
    process_group_collection nil
    production_space nil
    staging_space nil
  end
end
