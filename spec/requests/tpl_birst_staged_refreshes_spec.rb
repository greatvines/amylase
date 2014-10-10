require 'rails_helper'

RSpec.describe "TplBirstStagedRefreshes", :type => :request do
  describe "GET /tpl_birst_staged_refreshes" do
    it "works! (now write some real specs)" do
      get tpl_birst_staged_refreshes_path
      expect(response).to have_http_status(200)
    end
  end
end
