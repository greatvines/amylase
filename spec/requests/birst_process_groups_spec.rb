require 'rails_helper'

RSpec.describe "BirstProcessGroups", :type => :request do
  describe "GET /birst_process_groups" do
    it "works! (now write some real specs)" do
      get birst_process_groups_path
      expect(response).to have_http_status(200)
    end
  end
end
