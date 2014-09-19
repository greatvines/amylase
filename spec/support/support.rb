# spec/support/support.rb

RSpec.configure do |config|

  config.before(:each, :rufus_job => true) do
    Amylase::Application.eager_load!
  end
end
