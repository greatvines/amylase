require 'rails_helper'

RSpec.describe "JobSchedulers", :type => :request do
  describe "GET /job_scheduler" do
    it "works! (now write some real specs)" do
      get job_scheduler_path
      expect(response.status).to be(200)
    end
  end
end
