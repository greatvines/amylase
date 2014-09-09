require 'rails_helper'

RSpec.describe "JobSchedulers", :type => :request do
  describe "GET /job_schedulers" do
    it "works! (now write some real specs)" do
      get job_schedulers_path
      expect(response.status).to be(200)
    end
  end
end
