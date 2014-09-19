require 'rails_helper'

RSpec.describe "TplDevTests", :type => :request do
  describe "GET /tpl_dev_tests" do
    it "works! (now write some real specs)" do
      get tpl_dev_tests_path
      expect(response.status).to be(200)
    end
  end
end
