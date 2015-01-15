FactoryGirl.define do
  factory :tpl_gooddata_extract do
    association :gooddata_project, factory: :gooddata_project
    association :destination_credential, factory: :external_credential
    destination_path 'reports/somefile.zip'
    append_timestamp true

    trait :with_full_job_spec do
      after(:build) do |tpl_gooddata_extract, evaluator|
        create :job_spec, job_template: tpl_gooddata_extract, client: tpl_gooddata_extract.gooddata_project.client
        create :tpl_gooddata_extract_report, destination_file_name: 'executed_report.csv', export_method: 'executed', tpl_gooddata_extract: tpl_gooddata_extract
        create :tpl_gooddata_extract_report, destination_file_name: 'raw_report.csv', export_method: 'raw', tpl_gooddata_extract: tpl_gooddata_extract
      end
    end

  end
end
