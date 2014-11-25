require 'rails_helper'

RSpec.describe "BirstExtractGroups", :type => :request do
  describe "GET /birst_extract_groups" do
    it "works! (now write some real specs)" do
      get birst_extract_groups_path
      expect(response).to have_http_status(200)
    end
  end
end
