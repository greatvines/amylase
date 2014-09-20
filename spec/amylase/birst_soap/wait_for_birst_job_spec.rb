require 'rails_helper'

describe "wait_for_birst_job", :birst_soap_mock => true do
  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  include BirstSoapSupport


  before do
    Settings.birst_soap.wait.timeout = '5s'
    Settings.birst_soap.wait.every = '0.3s'
    Settings.birst_soap.rufus_freq = '0.1s'
  end

  after do 
    Settings.reload!
  end

  context "complete status is true" do
    before do
      mock_is_job_complete(false)
      mock_is_job_complete(true)
      mock_job_status("Complete")
    end
    it "completes successfully" do
      expect(wait_task.result_data[:final_status][:status_code]).to eq "Complete"
    end
  end

  context "running too long" do
    before do 
      # Having trouble with Savon expectations, so I have to make it timeout between wait calls
      Settings.birst_soap.wait.timeout = '2s'
      Settings.birst_soap.wait.every = '1.1s'
      mock_is_job_complete(false)
    end

    after { Settings.reload! }

    it "raises a timeout error" do
      expect { wait_task }.to raise_error Amylase::BirstSoap::BWSWaitTimeoutError
    end
  end

  context "with a token expiration error" do
    before do
      mock_is_job_complete(false)

      job_token_message = { :token => BirstSoapFixtures.login_token, :jobToken => BirstSoapFixtures.job_token }
      mock_login do
        savon.expects(:is_job_complete)
          .with(message: job_token_message)
          .returns(BirstSoapFixtures.token_expiration_error)
      end
    end

    it "raises an invalid token error" do
      expect { wait_task }.to raise_error Amylase::BirstSoap::BWSInvalidTokenError
    end
  end

  context "with a recoverable error" do

    before { Settings.birst_soap.wait.max_retry = 1 }

    context "that recovers" do
      before do
        mock_is_job_complete(false)

        job_token_message = { :token => BirstSoapFixtures.login_token, :jobToken => BirstSoapFixtures.job_token }
        mock_login do
          savon.expects(:is_job_complete)
            .with(message: job_token_message)
            .returns(BirstSoapFixtures.server_request_error)
        end

        mock_is_job_complete(true)
        mock_job_status("Complete")
      end

      it "completes successfully" do
        expect(wait_task.result_data[:final_status][:status_code]).to eq "Complete"
      end
    end

    context "that does not recover" do
      before do
        mock_is_job_complete(false)

        job_token_message = { :token => BirstSoapFixtures.login_token, :jobToken => BirstSoapFixtures.job_token }
        1.upto(2).each do 
          mock_login do
            savon.expects(:is_job_complete)
              .with(message: job_token_message)
              .returns(BirstSoapFixtures.server_request_error)
          end
        end
      end

      it "fails with a server request error" do
        expect { wait_task }.to raise_error Amylase::BirstSoap::BWSServerRequestError
      end

    end
  end
end
