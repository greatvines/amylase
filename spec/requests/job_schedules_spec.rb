require 'rails_helper'

RSpec.describe "JobSchedules", :type => :request do
  describe "GET /job_schedules" do
    it "works! (now write some real specs)" do
      get job_schedules_path
      expect(response.status).to be(200)
    end
  end
end
