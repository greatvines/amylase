# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_source do
    name "MyText"
    birst_filename "MyText"
    data_source_type "MyText"
    redshift_sql "MyText"
    s3_path "MyText"
  end
end
