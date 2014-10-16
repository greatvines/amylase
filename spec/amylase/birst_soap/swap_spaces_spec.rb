require 'rails_helper'

describe "Swapping spaces", :birst_soap_mock => true do
  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  include BirstSoapSupport

  before do
    Settings.birst_soap.wait.timeout = '5s'
    Settings.birst_soap.wait.every = '0.3s'
    Settings.birst_soap.rufus_freq = '0.1s'
  end

  after { Settings.reload! }

  context "successful swap, wait, complete cycle" do
    before { mock_swap_spaces }

    it "completes successfully" do
      swap_spaces(BirstSoapFixtures.space_id_1, BirstSoapFixtures.space_id_2)
    end
  end
end

