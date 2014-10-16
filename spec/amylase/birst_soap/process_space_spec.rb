require 'rails_helper'

describe "Processing a space", :birst_soap_mock => true do
  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  include BirstSoapSupport

  before do
    Settings.birst_soap.wait.timeout = '5s'
    Settings.birst_soap.wait.every = '0.3s'
    Settings.birst_soap.rufus_freq = '0.1s'
  end

  after { Settings.reload! }

  context "successful process, wait, complete cycle" do
    before do
      some_time = Time.now
      allow(Time).to receive(:now) { some_time }
      mock_process_data
    end

    it "completes successfully" do
      process_space(BirstSoapFixtures.space_id_1)
    end
  end

  context "with a set of extract groups" do
    before do
      @process_groups = FactoryGirl.build(:birst_process_group_collection, :with_existing_groups).birst_process_groups.to_a
      mock_extract_data(extract_groups: @extract_groups)
    end

    it "completes successfully" do
      extract_space(BirstSoapFixtures.space_id_1, extract_groups: @extract_groups)
    end
  end
end

