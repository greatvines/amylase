require 'rails_helper'

RSpec.describe "ExternalCredentials", :type => :request do
  describe "GET /external_credentials" do
    it "works! (now write some real specs)" do
      get external_credentials_path
      expect(response).to have_http_status(200)
    end
  end
end
