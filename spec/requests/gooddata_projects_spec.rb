require 'rails_helper'

RSpec.describe "GooddataProjects", :type => :request do
  describe "GET /gooddata_projects" do
    it "works! (now write some real specs)" do
      get gooddata_projects_path
      expect(response).to have_http_status(200)
    end
  end
end
