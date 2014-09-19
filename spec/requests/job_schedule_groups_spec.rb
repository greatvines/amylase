require 'rails_helper'

RSpec.describe "JobScheduleGroups", :type => :request do
  describe "GET /job_schedule_groups" do
    it "works! (now write some real specs)" do
      get job_schedule_groups_path
      expect(response.status).to be(200)
    end
  end
end
