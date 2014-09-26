require 'rails_helper'

describe Amylase::BirstSoap::Session do
  include BirstSoapSupport
  Session = Amylase::BirstSoap::Session

  before { Settings.birst_soap.soap_log_level = :debug }

  shared_examples_for "Log in and out" do

    context "by calling the object methods directly" do
      specify "without options" do
        mysession = Session.new
        expect(mysession.login).to be_successful
        mysession.logout
      end

      specify "with options" do
        mysession = Session.new :soap_log_level => :error, :soap_logger => Logger.new(STDOUT)
        expect(mysession.login).to be_successful
        mysession.logout
      end
    end

    context "in a session block" do
      specify "without options" do
        Session.new do |bc|
        end
      end

      specify "with options" do
        Session.new :soap_log_level => :error, :soap_logger => Logger.new(STDOUT) do |bc|
        end
      end
    end
  end


  shared_examples_for "list spaces" do
    describe "list spaces" do
      it "should list spaces" do
        spaces = nil
        Session.new do |bc|
          spaces = bc.list_spaces
        end

        expect(spaces[:user_space].length).to be > 0
      end
    end
  end

  shared_examples_for "list users in space" do
    describe "list users in space" do
      it "should list the users in the space" do
        users = nil
        Session.new do |bc|
          users = bc.list_users_in_space :spaceID => spaceID
        end

        expect(users[:string].length).to be > 0
      end
    end
  end



  describe "simple birst web service calls with mock objects" do

    context "with mock objects", :birst_soap_mock => true do

      context "mock log in and out" do
        before { mock_login_and_out }
        it_behaves_like "Log in and out"
      end

      context "mock list spaces" do
        before do
          mock_login_and_out { savon.expects(:list_spaces).with(message: { :token => BirstSoapFixtures.login_token }).returns(BirstSoapFixtures.list_spaces) }
        end
        it_behaves_like "list spaces"
      end

      context "mock list users in spaces" do
        let(:spaceID) { "b7f3df39-438c-4ec7-bd29-489f41afde14" }
        before do
          message = { :token => BirstSoapFixtures.login_token, :spaceID => spaceID }
          mock_login_and_out { savon.expects(:list_users_in_space).with(message: message).returns(BirstSoapFixtures.list_users_in_space) }
        end
        it_behaves_like "list users in space"
      end
    end

    context "with live connection", :live => true do
      it_behaves_like "Log in and out"
      it_behaves_like "list spaces"

      let(:spaceID) do
        spaces = nil
        Session.new { |bc| spaces = bc.list_spaces }
        spaces[:user_space][0][:id]
      end
      it_behaves_like "list users in space"
    end

  end


  describe "cookie handling", :live => true do
    before do
      Session.new do |bc|
        @space_id = bc.create_new_space(
          :spaceName => "Birst_Command-Spec-#{SecureRandom.hex(4)}",
          :comments => "",
          :automatic => "false"
        )
        @cookie = bc.auth_cookie
      end
    end

    # Example data chunk to upload
    let(:data_chunk) do
      <<-EOT.unindent
      category,value
      A,1
      B,2
      C,3
      D,4
      E,5
      EOT
    end

    after do
      Session.new { |bc| bc.delete_space :spaceId => @space_id }
    end


    it "enforces login environment" do
      upload_token = nil
      Session.new auth_cookie: @cookie do |bc|
        upload_token = bc.begin_data_upload(:spaceID => @space_id, 
                                            :sourceName => "MyTestData"
                                           )
      end

      Session.new auth_cookie: @cookie, soap_log_level: :error do |bc|
        bc.upload_data(:dataUploadToken => upload_token,
                       :numBytes => data_chunk.bytesize,
                       :data => Base64.encode64(data_chunk)
                       )
      end

      Session.new auth_cookie: @cookie do |bc|
        bc.finish_data_upload(:dataUploadToken => upload_token)
      end

      Session.new auth_cookie: @cookie do |bc|
        upload_complete = bc.is_data_upload_complete(:dataUploadToken => upload_token)
      end

    end
  end
end
