require 'rails_helper'

RSpec.describe "DataSourceCollections", :type => :request do
  describe "GET /data_source_collections" do
    it "works! (now write some real specs)" do
      get data_source_collections_path
      expect(response).to have_http_status(200)
    end
  end
end
