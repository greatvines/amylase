require 'rails_helper'

describe 'Deleting all data', :birst_soap_mock => true do
  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  include BirstSoapSupport

  before do
    Settings.birst_soap.wait.timeout = '5s'
    Settings.birst_soap.wait.every = '0.3s'
    Settings.birst_soap.rufus_freq = '0.1s'
  end

  after { Settings.reload! }

  context 'successful delete, wait, complete cycle' do
    before { mock_delete_all_data }

    it 'completes successfully' do
      expect(delete_all_data(BirstSoapFixtures.space_id_1).result_data[:final_status][:status_code]).to eq 'Complete'
    end
  end
end

