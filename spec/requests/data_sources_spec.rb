require 'rails_helper'

RSpec.describe "DataSources", :type => :request do
  describe "GET /data_sources" do
    it "works! (now write some real specs)" do
      get data_sources_path
      expect(response).to have_http_status(200)
    end
  end
end
