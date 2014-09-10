json.array!(@tpl_dev_tests) do |tpl_dev_test|
  json.extract! tpl_dev_test, :id, :argument
  json.url tpl_dev_test_url(tpl_dev_test, format: :json)
end
