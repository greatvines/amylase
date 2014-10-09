require 'rails_helper'

RSpec.describe "DataSourceGroups", :type => :request do
  describe "GET /data_source_groups" do
    it "works! (now write some real specs)" do
      get data_source_groups_path
      expect(response).to have_http_status(200)
    end
  end
end
