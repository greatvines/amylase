require 'rails_helper'
require_relative 'birst_soap_helper'

describe "wait_for_birst_job", skip: "Need to get logging to work first" do

  before do
    savon.mock!
    Settings.birst_soap.wait.timeout = '5s'
    Settings.birst_soap.wait.every = '0.3s'
  end

  after { savon.unmock! }

  context "complete status is true" do
    before do
      mock_is_job_complete(false)
      mock_is_job_complete(true)
      mock_job_status("Complete")
    end
    subject { wait_job[:status_message][:status_code] }
    it { is_expected.to eq "Complete" }
  end

  context "running too long" do
    before do
      mock_is_job_complete(false,10)
      mock_is_job_complete(true)
      mock_job_status("Complete")
    end
    subject { lambda { wait_job } }
    it { is_expected.to raise_error BWSError::BWSWaitTimeoutError }
  end

  context "with a token expiration error" do
    before do
      mock_is_job_complete(false)

      job_token_message = { :token => BCSpecFixtures.login_token, :jobToken => BCSpecFixtures.job_token }
      mock_login do
        savon.expects(:is_job_complete)
          .with(message: job_token_message)
          .returns(BCSpecFixtures.token_expiration_error)
      end
    end

    subject { lambda { wait_job } }
    it { is_expected.to raise_error BWSError::BWSInvalidTokenError }
  end

  context "with a recoverable error" do

    before { Settings.bws_wait_max_retry = 1 }

    context "that recovers" do
      before do
        mock_is_job_complete(false)

        job_token_message = { :token => BCSpecFixtures.login_token, :jobToken => BCSpecFixtures.job_token }
        mock_login do
          savon.expects(:is_job_complete)
            .with(message: job_token_message)
            .returns(BCSpecFixtures.server_request_error)
        end

        mock_is_job_complete(true)
        mock_job_status("Complete")
      end

      subject { wait_job[:status_message][:status_code] }
      it { is_expected.to eq "Complete" }

    end

    context "that does not recover" do
      before do
        mock_is_job_complete(false)

        job_token_message = { :token => BCSpecFixtures.login_token, :jobToken => BCSpecFixtures.job_token }
        1.upto(5).each do 
          mock_login do
            savon.expects(:is_job_complete)
              .with(message: job_token_message)
              .returns(BCSpecFixtures.server_request_error)
          end
        end
      end

      subject { lambda { wait_job } }
      it { is_expected.to raise_error BWSError::BWSServerRequestError }

    end
  end
end
