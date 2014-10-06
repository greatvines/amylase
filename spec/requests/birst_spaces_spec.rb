require 'rails_helper'

RSpec.describe "BirstSpaces", :type => :request do
  describe "GET /birst_spaces" do
    it "works! (now write some real specs)" do
      get birst_spaces_path
      expect(response).to have_http_status(200)
    end
  end
end
