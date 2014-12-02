require 'rails_helper'

RSpec.describe "BirstExtractGroupCollections", :type => :request do
  describe "GET /birst_extract_group_collections" do
    it "works! (now write some real specs)" do
      get birst_extract_group_collections_path
      expect(response).to have_http_status(200)
    end
  end
end
