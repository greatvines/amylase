require 'rails_helper'

RSpec.describe "TplGooddataExtractReports", :type => :request do
  describe "GET /tpl_gooddata_extract_reports" do
    it "works! (now write some real specs)" do
      get tpl_gooddata_extract_reports_path
      expect(response).to have_http_status(200)
    end
  end
end
