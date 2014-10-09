# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_source do
    sequence(:name) { |n| "MyDataSource-#{n}" }
    birst_filename "MyFilename"
    data_source_type "RedshiftS3DataSource"
    redshift_sql Settings.test.redshift_query

    trait :s3_data_source do
      data_source_type 'S3DataSource'
      s3_path Settings.test.s3_file
    end

    trait :redshift_s3_data_source do
    end
  end
end
