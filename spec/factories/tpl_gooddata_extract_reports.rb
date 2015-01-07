FactoryGirl.define do
  factory :tpl_gooddata_extract_report do
    sequence(:name) { |n| "MyGooddataExtractReport-#{n}" }
    report_oid '12345'
    destination_file_name "somefile.csv"
    tpl_gooddata_extract
  end
end
