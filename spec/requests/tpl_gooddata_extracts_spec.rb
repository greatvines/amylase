require 'rails_helper'

RSpec.describe "TplGooddataExtracts", :type => :request do
  describe "GET /tpl_gooddata_extracts" do
    it "works! (now write some real specs)" do
      get tpl_gooddata_extracts_path
      expect(response).to have_http_status(200)
    end
  end
end
