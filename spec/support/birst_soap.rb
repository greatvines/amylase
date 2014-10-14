# spec/support/birst_soap.rb
require 'savon/mock/spec_helper'

RSpec.configure do |config|
  config.before(:each, :birst_soap_mock => true) do
    savon.mock!

    stub_request(:get, "https://app2102.bws.birst.com/CommandWebService.asmx?WSDL")
      .with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'HTTPClient/1.0 (2.4.0, ruby 2.0.0 (2013-11-22))'})
      .to_return(:status => 200, :body => File.open(File.join(Rails.root, 'spec/support/birst_soap_wsdl_app2102_5_13.xml')).read, :headers => {})
  end

  config.after(:each, :birst_soap_mock => true) do
    savon.unmock!
  end
end

module BirstSoapSupport
  include Savon::SpecHelper

  def initialize(*args, &block)
    super
    @job_log = Logging.logger['JobLog']
    @job_log.level = :debug
    @job_log.add_appenders(Logging.appenders.stdout)

    @login_message = { :token => BirstSoapFixtures.login_token }
  end

  def mock_login(&block)
    crypt = Envcrypt::Envcrypter.new

    message = { :username => Settings.birst_soap.session.username, :password => crypt.decrypt(Settings.birst_soap.session.password) }
    savon.expects(:login).with(message: message).returns(BirstSoapFixtures.login)
    yield if block_given?
  end

  def mock_login_and_out(&block)
    mock_login(&block)
    savon.expects(:logout).with(message: @login_message).returns(BirstSoapFixtures.logout)
  end


  def mock_is_complete(status, ntimes = 1, type = :job)
    message = @login_message.dup

    case type
    when :job
      message[:jobToken] = BirstSoapFixtures.job_token
      command = :is_job_complete
      response = BirstSoapFixtures.copy_space_is_job_complete(status)
    when :publish
      message[:publishingToken] = BirstSoapFixtures.job_token
      command = :is_publishing_complete
      response = BirstSoapFixtures.publish_is_job_complete(status)
    when :upload
      message[:dataUploadToken] = BirstSoapFixtures.job_token
      command = :is_data_upload_complete
      response = BirstSoapFixtures.is_data_upload_complete_response(status)
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
    message = @login_message.dup

    case type
    when :job
      message[:jobToken] = BirstSoapFixtures.job_token
      command = :get_job_status
      response = BirstSoapFixtures.copy_space_job_status(status)
    when :publish
      message[:publishingToken] = BirstSoapFixtures.job_token
      command = :get_publishing_status
      response = BirstSoapFixtures.publish_job_status(status)
    when :upload
      message[:dataUploadToken] = BirstSoapFixtures.job_token
      command = :get_data_upload_status
      response = BirstSoapFixtures.get_data_upload_status_response(status)
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


  def wait_task
    wait_for_birst_job(
      complete:     :is_job_complete,
      status:       :get_job_status,
      token_name:   :jobToken,
      job_token:    BirstSoapFixtures.job_token
    )
  end

  def mock_copy_space(options: "data;datastore")
    mock_login_and_out do 
      savon.expects(:copy_space)
        .with(message: BirstSoapFixtures.copy_space_message(options: options))
        .returns(BirstSoapFixtures.copy_space_response)
    end
    mock_is_job_complete(true)
    mock_job_status("Complete")
  end


  def mock_delete_all_data(space_id = BirstSoapFixtures.space_id_1)
    mock_login_and_out do
      savon.expects(:delete_all_data_from_space)
        .with(message: @login_message.merge({ :spaceID => space_id }))
        .returns(BirstSoapFixtures.delete_all_data_response)
    end

    mock_is_job_complete(true)
    mock_job_status('Complete')
  end


  def mock_extract_data(space_id = BirstSoapFixtures.space_id_1, extract_groups: nil)
    mock_login_and_out do
      savon.expects(:extract_connector_data)
        .with(message: @login_message.merge({ :spaceID => space_id, :connectorName => 'Salesforce', :extractGroups => { 'string' => extract_groups } }))
        .returns(BirstSoapFixtures.extract_connector_data_response)
    end

    mock_is_job_complete(true)
    mock_job_status('Complete')
  end

  def mock_process_data(space_id = BirstSoapFixtures.space_id_1, timestamp: Time.now, process_groups: nil)
    mock_login_and_out do
      savon.expects(:publish_data)
        .with(message: @login_message.merge({ :spaceID => space_id, :date => timestamp.strftime("%Y-%m-%dT%H:%M:%S%:z"), :subgroups => { 'string' => process_groups } }))
        .returns(BirstSoapFixtures.publish_data_response)
    end

    mock_is_publish_complete(true)
    mock_publish_status('Complete')
  end
end
