require 'rails_helper'

describe Amylase::GooddataRest do
  include GooddataRestSupport

  context 'Gooddata REST mocks', :gooddata_rest_mock do
    before do
      @stub_username = 'user@example.com'
      @stub_password = '123456'
      @stub_pid = 'd2xg1ood0pnvw57yckqbaj3nhvn1vhqs'
      @stub_obj = '4794'

      stub_post_gdc_account_login
      stub_get_gdc_account_token

      @gd_conn = Amylase::GooddataRest.new(
                  username: @stub_username,
                  password: @stub_password,
                  rest_log: @job_log
                )
    end

    context 'initializing the REST connection' do
      it 'logs in' do
        expect(stub_post_gdc_account_login).to have_been_requested
      end

      it 'gets the TT token cookie' do
        expect(stub_get_gdc_account_token).to have_been_requested
      end

      it 'sets the TT token cookie to the expected value' do
        expect(@gd_conn.token_cookie).to eq @stub_token_cookie
      end
    end

    context 'querying reports' do
      before do
        stub_get_gdc_md_pid_query_reports

        @reports = @gd_conn.get_reports(@stub_pid)
      end

      it 'queries the reports' do
        expect(stub_get_gdc_md_pid_query_reports).to have_been_requested
      end

      it 'returns the expected reports metadata' do
        expect(@reports).to eq JSON.parse(stub_response_reports)
      end
    end

    context 'downloading an executed report' do
      before do
        stub_post_gdc_xtab2_executor3
        stub_post_gdc_exporter_executor
        stub_download_uri_executed

        @tempfile = Tempfile.new('test.csv')
        @gd_conn.export_report(pid: @stub_pid, obj: @stub_obj, local_file_name: @tempfile.path)
      end

      after { @tempfile.unlink }

      it 'calls the report executor' do
        expect(stub_post_gdc_xtab2_executor3).to have_been_requested
      end

      it 'calls the report exporter' do
        expect(stub_post_gdc_exporter_executor).to have_been_requested
      end

      it 'gets the expected data' do
        expect(@tempfile.read).to eq stub_download_data_executed_plaintext
      end
    end


    context 'downloading a raw report' do
      before do
        stub_post_gdc_app_projects_pid_execute_raw
        stub_download_uri_raw

        @tempfile = Tempfile.new('test.csv')
        @gd_conn.export_report(method: :raw, pid: @stub_pid, obj: @stub_obj, local_file_name: @tempfile.path)
      end

      after { @tempfile.unlink }

      it 'calls the raw report exporter' do
        expect(stub_post_gdc_app_projects_pid_execute_raw).to have_been_requested
      end

      it 'gets the expected data' do
        expect(@tempfile.read).to eq stub_download_data_raw_plaintext
      end
    end
  end


  context 'live dev', :webmock_logging, skip: 'Unskip to capture new stubs' do
    it 'connects and does whatever' do
      @stub_username = ENV['TEST_GOODDATA_STUB_USERNAME']
      @stub_password = ENV['TEST_GOODDATA_STUB_PASSWORD']
      @stub_pid = 'd2xg1ood0pnvw57yckqbaj3nhvn1vhqs'
      @stub_obj = '4794'

      @gd_conn = Amylase::GooddataRest.new(
                  username: @stub_username,
                  password: @stub_password,
                  rest_log: @job_log
                )
      response = @gd_conn.post_gdc_app_projects_pid_execute_raw(pid: @stub_pid, obj: @stub_obj)
      uri = JSON.parse(response)['uri']

      @gd_conn.download_uri(uri: uri, local_file_name: 'test.csv')
    end
  end
end
