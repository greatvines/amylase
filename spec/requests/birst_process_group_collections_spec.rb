require 'rails_helper'

RSpec.describe "BirstProcessGroupCollections", :type => :request do
  describe "GET /birst_process_group_collections" do
    it "works! (now write some real specs)" do
      get birst_process_group_collections_path
      expect(response).to have_http_status(200)
    end
  end
end
