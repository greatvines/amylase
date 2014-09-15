require_relative 'birst_soap_fixtures'
require 'savon/mock/spec_helper'

include Savon::SpecHelper

module Amylase
  module BirstSoap
    module SpecHelper

      def mock_login(&block)
        crypt = Envcrypt::Envcrypter.new

        message = { :username => Settings.birst_soap.session.username, :password => crypt.decrypt(Settings.birst_soap.session.password) }
        savon.expects(:login).with(message: message).returns(SpecFixtures.login)
        yield if block_given?
      end

      def mock_login_and_out(&block)
        mock_login(&block)
        savon.expects(:logout).with(message: { :token => SpecFixtures.login_token }).returns(SpecFixtures.logout)
      end


      def mock_is_complete(status, ntimes = 1, type = :job)
        message = { :token => SpecFixtures.login_token }

        case type
        when :job
          message[:jobToken] = SpecFixtures.job_token
          command = :is_job_complete
          response = SpecFixtures.copy_space_is_job_complete(status)
        when :publish
          message[:publishingToken] = SpecFixtures.job_token
          command = :is_publishing_complete
          response = SpecFixtures.publish_is_job_complete(status)
        when :upload
          message[:dataUploadToken] = SpecFixtures.job_token
          command = :is_data_upload_complete
          response = SpecFixtures.is_data_upload_complete_response(status)
        end

        1.upto(ntimes).each do
          mock_login_and_out do
            savon.expects(command)
              .with(message: message)
              .returns(response)
          end
        end
      end

      def mock_is_job_complete(status, ntimes=1)
        mock_is_complete(status, ntimes, :job)
      end

      def mock_is_publish_complete(status, ntimes=1)
        mock_is_complete(status, ntimes, :publish)
      end

      def mock_is_upload_complete(status, ntimes=1)
        mock_is_complete(status, ntimes, :upload)
      end


      def mock_status(status, type = :job)
        message = { :token => SpecFixtures.login_token }

        case type
        when :job
          message[:jobToken] = SpecFixtures.job_token
          command = :get_job_status
          response = SpecFixtures.copy_space_job_status(status)
        when :publish
          message[:publishingToken] = SpecFixtures.job_token
          command = :get_publishing_status
          response = SpecFixtures.publish_job_status(status)
        when :upload
          message[:dataUploadToken] = SpecFixtures.job_token
          command = :get_data_upload_status
          response = SpecFixtures.get_data_upload_status_response(status)
        end

        mock_login_and_out do
          savon.expects(command)
            .with(message: message)
            .returns(response)
        end
      end

      def mock_job_status(status)
        mock_status(status, :job)
      end

      def mock_publish_status(status)
        mock_status(status, :publish)
      end

      def mock_upload_status(status)
        mock_status(status, :upload)
      end


      def wait_job
        job = JobTemplate.new
        result = job.wait_for_birst_job(
          complete:     :is_job_complete,
          status:       :get_job_status,
          token_name:   :jobToken,
          job_token:    SpecFixtures.job_token
        )
        result
      end
    end
  end
end


include Amylase::BirstSoap
include Amylase::BirstSoap::SpecHelper
