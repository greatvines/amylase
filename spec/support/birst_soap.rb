require 'savon/mock/spec_helper'

module BirstSoapSupport
  include Savon::SpecHelper

  def initialize(*args, &block)
    super
    @job_log = Logging.logger['JobLog']
    @job_log.level = :debug
    @job_log.add_appenders(Logging.appenders.stdout)
  end

  def mock_login(&block)
    crypt = Envcrypt::Envcrypter.new

    message = { :username => Settings.birst_soap.session.username, :password => crypt.decrypt(Settings.birst_soap.session.password) }
    savon.expects(:login).with(message: message).returns(BirstSoapFixtures.login)
    yield if block_given?
  end

  def mock_login_and_out(&block)
    mock_login(&block)
    savon.expects(:logout).with(message: { :token => BirstSoapFixtures.login_token }).returns(BirstSoapFixtures.logout)
  end


  def mock_is_complete(status, ntimes = 1, type = :job)
    message = { :token => BirstSoapFixtures.login_token }

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
    message = { :token => BirstSoapFixtures.login_token }

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
end
