module Amylase

  # Public: Methods needed to interface with the Gooddata REST API.
  # The Gooddata REST documention is provided here:
  # https://developer.gooddata.com/api
  class GooddataRest

    DEFAULT_URL_BASE = 'https://secure.gooddata.com'

    # Public: Simple class to hold headers and values for REST queries.
    class RestParams

      # Public: Initializes the REST parameters (headers and values).  Headers
      # and values may either be a hash or a JSON-formatted string.  Strings
      # are converted and stored as a hash.
      #
      # headers - The REST headers parameters.  May be a hash or a JSON-formatting string.
      # values  - The REST values parameters.  May be a hash or a JSON-formatting string.
      def initialize(headers: {}, values: {})
        self.headers = headers
        self.values = values
      end

      # Public: Returns the headers parameters as a hash.
      attr_reader :headers

      # Public: Returns the values parameters as a hash.
      attr_reader :values

      # Public: Setter for the headers.  Strings are parsed with JSON.  Otherwise,
      # it assumes the headers are stored as a hash.
      def headers=(val)
        @headers = val.is_a?(String) ? JSON.parse(val) : val
      end

      # Public: Setter for the values.  Strings are parsed with JSON.  Otherwise,
      # it assumes the values are stored as a hash.
      def values=(val)
        @values = val.is_a?(String) ? JSON.parse(val) : val
      end
    end




    # Public: Initializes a Gooddata REST connection.
    #
    # username - Name of user to establish Gooddata connection.
    # password - Password to use for user to establish Gooddata connection.
    # rest_log - Logger object to use to log REST queries and results.
    # url_base - Base Gooddata API URL (default: DEFAULT_URL_BASE).
    def initialize(username: nil, password: nil, rest_log: Rails.logger, url_base: DEFAULT_URL_BASE)
      @url_base = url_base
      @rest_log = rest_log

      @token_cookie = login(username, password)      
    end

    # Public: Reader for the token cookie (aka short-lived TT token).
    attr_reader :token_cookie


    # Public: Method to ping the Gooddata server to check for availability.
    #
    # Returns a RestClient::Response when successful.
    def self.ping(url_base: DEFAULT_URL_BASE)
      rest_client :get, "#{url_base}/gdc/ping" do |params|
        params.headers = {
          :accept => 'application/json'
        }
      end
    end


    # Public: Gets a list of all reports and report metadata for a Gooddata project id.
    #
    # pid - The Gooddata project id to query.
    #
    # Returns a hash representing all the reports and report metadata.
    def get_reports(pid)
      JSON.parse(get_gdc_md_pid_query_reports(pid))
    end


    # Public: Exports a specified report to a local csv file.
    #
    # method          - Reports can either be exported using the :executed or
    #                   :raw methods.  In :executed mode, the report will
    #                   closely resemble the report as expressed in Gooddata.
    #                   However, :executed cannot be used for very large
    #                   reports.  Large reports will fail to show up in the
    #                   Gooddata GUI but can still be exported using the :raw
    #                   method.  The :raw method may not display crosstabs in the 
    #                   same format as :executed, but it is the only way to export
    #                   large reports.
    # pid             - The Gooddata project id.
    # obj             - The object number of the report.  This is typically the
    #                   few digits that follow '../obj/' in the report URL.
    # local_file_name - Name of the file that the report will be exported to.
    #
    # Returns nothing.
    def export_report(method: :executed, pid:, obj:, local_file_name:)
      case method
      when :executed
        export_report_executed(pid: pid, obj: obj, local_file_name: local_file_name)
      when :raw
        export_report_raw(pid: pid, obj: obj, local_file_name: local_file_name)
      else
        raise "Unknown report export method: #{method} - expecting one of [:executed, :raw]"
      end
    end


    private

    # Private: Wrapper for the Gooddata REST client that performs logging and simplifies
    # setting REST parameters.
    #
    # method - Symbol speciying the REST method to use.  Curerntly only support :get and :put.
    # url    - Full URL to make the request against.
    # log    - Array that specifies whether requests and/or responses should be logged.
    #          Sometimes it is necessary to turn of response logging for large responses 
    #          (e.g., data files).  (default: [:request, :response]).
    # &block - This method only works by specifying a block. It yeilds
    #          a RestParams object where the user sets the REST headers and values.
    #
    # Examples
    #
    #  rest_client :post, "#{url_base}/gdc/account/login" do |params|
    #    params.headers = {
    #      content_type: 'application/json',
    #      accept: 'application/json'
    #    }
    #
    #    params.values = {
    #      postUserLogin: {
    #        login: "#{username}",
    #        password: "#{password}",
    #        remember: 1
    #      }
    #    }
    #  end
    #
    # Returns a RestClient::Response when successful.
    def rest_client(method, url, log: [:request, :response], &block)
      params = RestParams.new
      yield params

      if Array(log).include? :request
        masked_values = params.values.to_json
        if params.values[:postUserLogin] && params.values[:postUserLogin][:password]
          masked_values = masked_values.gsub(/#{params.values[:postUserLogin][:password]}/,'******')
        end

        @rest_log.info "#{method.upcase}: #{url}"
        @rest_log.info "HEADERS: #{params.headers}"
        @rest_log.info "VALUES: #{masked_values}"
      end

      response = case method
      when :get
        RestClient.get url, params.headers
      when :post
        RestClient.post url, params.values.to_json, params.headers
      else
        raise "Unkown RestClient method #{method}"
      end

      @rest_log.info "RESPONSE: #{response}" if Array(log).include? :response

      response
    end

    # Private: Logs in to Gooddata.
    #
    # Returns the token cookie (TT token) needed to perform all subsequent queries.
    def login(username, password)
      login_response = post_gdc_account_login(username, password)
      get_gdc_account_token(login_response).headers[:set_cookie].join(',')
    end


    # Private: POST /gdc/account/login
    #
    # username - Username to use for login.
    # password - Password to use for login.
    #
    # Returns a RestClient::Response when successful.
    def post_gdc_account_login(username, password)
      rest_client :post, "#{@url_base}/gdc/account/login" do |params|
        params.headers = {
          content_type: 'application/json',
          accept: 'application/json'
        }

        params.values = {
          postUserLogin: {
            login: "#{username}",
            password: "#{password}",
            remember: 1
          }
        }
      end
    end

    # Private: GET /gdc/account/token
    #
    # login_response - The RestClient::Response object that is returned from the REST login request.
    #
    # Returns a RestClient::Response when successful.
    def get_gdc_account_token(login_response)
      rest_client :get, "#{@url_base}/gdc/account/token" do |params|
        params.headers = {
          :accept => 'application/json',
          :cookie => login_response.headers[:set_cookie].join(',')
        }
      end
    end

    # Private: GET gdc/md/{project-id}/query/reports
    #
    # pid - The Gooddata project id to query.
    #
    # Returns a RestClient::Response when successful.
    def get_gdc_md_pid_query_reports(pid=nil)
      rest_client :get, "#{@url_base}/gdc/md/#{pid}/query/reports" do |params|
        params.headers = {
          :accept => 'application/json',
          :cookie => @token_cookie
        }
      end
    end

    # Private: POST gdc_app_projects_pid_execute_raw
    #
    # pid - The Gooddata project id to execute.
    # obj - The Gooddata report object to execute.
    #
    # Returns a RestClient::Response when successful.
    def post_gdc_app_projects_pid_execute_raw(pid:, obj:)
      rest_client :post, "#{@url_base}/gdc/app/projects/#{pid}/execute/raw" do |params|
        params.values = {
          report_req: {
            report: "/gdc/md/#{pid}/obj/#{obj}"
          }
        }

        params.headers = {
          :content_type => 'application/json',
          :accept => 'application/json',
          :cookie => @token_cookie
        }
      end
    end

    # Private: POST gdc/xtab2/executor3
    #
    # pid - The Gooddata project id to execute.
    # obj - The Gooddata report object to execute.
    #
    # Returns a RestClient::Response when successful.
    def post_gdc_xtab2_executor3(pid:, obj:)
      rest_client :post, "#{@url_base}/gdc/xtab2/executor3" do |params|
        params.values = {
          report_req: {
            report: "/gdc/md/#{pid}/obj/#{obj}"
          }
        }

        params.headers = {
          :content_type => 'application/json',
          :accept => 'application/json',
          :cookie => @token_cookie
        }
      end
    end

    # Private: POST /gdc/exporter/executor
    #
    # executor - The JSON-parsed RestClient::Response object that
    #            results from the post_gdc_xtab2_executor3 call.
    #
    # Returns a RestClient::Response when successful.
    def post_gdc_exporter_executor(executor:)
      rest_client :post, "#{@url_base}/gdc/exporter/executor" do |params|
        params.values = {
          result_req: {
            format: "csv",
            result: executor
          }
        }

        params.headers = {
          :content_type => 'application/json',
          :accept => 'application/json',
          :cookie => @token_cookie
        }
      end
    end

    # Private: Downlaods a file from a the given URI.
    #
    # uri             - The URI to download a report from.
    # local_file_name - The name of the file to save the URI to.
    #
    # Returns nothing.
    def download_uri(uri:, local_file_name:)
      download_string = rest_client :get, "#{@url_base}#{uri}", log: :request do |params|
        params.headers = {
          :cookie => @token_cookie
        }
      end

      File.open(local_file_name, 'wb' ) do |output|
        output.write download_string
      end
    end

    # Private: Report exporter for :executed reports (see export_report for more details).
    def export_report_executed(pid:, obj:, local_file_name:)
      executor = post_gdc_xtab2_executor3(pid: pid, obj: obj)
      exporter = post_gdc_exporter_executor(executor: JSON.parse(executor))
      
      uri = JSON.parse(exporter)['uri']
      download_uri(uri: uri, local_file_name: local_file_name)
      
      nil
    end

    # Private: Report exporter for :raw reports (see export_report for more details).
    def export_report_raw(pid:, obj:, local_file_name:)
      exporter = post_gdc_app_projects_pid_execute_raw(pid: pid, obj: obj)

      uri = JSON.parse(exporter)['uri']
      download_uri(uri: uri, local_file_name: local_file_name)

      nil
    end
  end
end
