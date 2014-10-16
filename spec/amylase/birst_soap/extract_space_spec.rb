require 'rails_helper'

describe "Extracting a space", :birst_soap_mock => true do
  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  include BirstSoapSupport

  before do
    Settings.birst_soap.wait.timeout = '5s'
    Settings.birst_soap.wait.every = '0.3s'
    Settings.birst_soap.rufus_freq = '0.1s'
  end

  after { Settings.reload! }

  context "successful extract, wait, complete cycle" do
    before { mock_extract_data }

    it "completes successfully" do
      extract_space(BirstSoapFixtures.space_id_1)
    end
  end

  context "with a set of extract groups" do
    before do
      @extract_groups = ["one", "two", "three"]
      mock_extract_data(extract_groups: @extract_groups)
    end

    it "completes successfully" do
      extract_space(BirstSoapFixtures.space_id_1, extract_groups: @extract_groups)
    end
  end
end

