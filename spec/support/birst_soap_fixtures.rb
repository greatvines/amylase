module BirstSoapFixtures
  class << self

    def login_token
      "46a87e10b37e21653186ffe0973f54ae"
    end

    def space_id_1
      "b016c5c7-00ad-413a-a058-db78edef2961"
    end

    def space_id_2
      "b7f3df39-438c-4ec7-bd29-489f41afde14"
    end

    def job_token
      "75efafd80a7d2402353b1d86e26dfb62"
    end

    def login
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <LoginResponse xmlns="http://www.birst.com/">
            <LoginResult>#{login_token}</LoginResult>
          </LoginResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def logout
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <LogoutResponse xmlns="http://www.birst.com/"/>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def list_spaces
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <listSpacesResponse xmlns="http://www.birst.com/">
            <listSpacesResult>
              <UserSpace>
                <name>My_First_Space</name>
                <owner>user@example.com</owner>
                <id>#{space_id_1}</id>
              </UserSpace>
              <UserSpace>
                <name>My_Second_Space</name>
                <owner>user@example.com</owner>
                <id>#{space_id_2}</id>
              </UserSpace>
            </listSpacesResult>
          </listSpacesResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def list_users_in_space
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <listUsersInSpaceResponse xmlns="http://www.birst.com/">
            <listUsersInSpaceResult>
              <string>user@example.com</string>
              <string>myname@example.com</string>
              <string>coolbeans@example.com</string>
            </listUsersInSpaceResult>
          </listUsersInSpaceResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end


    def copy_space_message(mode: "replicate", options: "data;datastore")
      {
        :token => login_token,
        :spFromID => space_id_1,
        :spToID => space_id_2,
        :mode => mode,
        :options => options
      }
    end

    def copy_space_response
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <copySpaceResponse xmlns="http://www.birst.com/">
            <copySpaceResult>#{job_token}</copySpaceResult>
          </copySpaceResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def copy_space_is_job_complete(result=false)
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <isJobCompleteResponse xmlns="http://www.birst.com/">
            <isJobCompleteResult>#{result}</isJobCompleteResult>
          </isJobCompleteResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def copy_space_job_status(result="Complete")
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <getJobStatusResponse xmlns="http://www.birst.com/">
            <getJobStatusResult>
              <type>0</type>
              <loadid>0</loadid>
              <statusCode>#{result}</statusCode>
            </getJobStatusResult>
          </getJobStatusResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def copy_space_error
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <soap:Fault>
            <faultcode>soap:Client</faultcode>
            <faultstring>copySpace: User user@example.com failed to replicated space for b016c5c7-00ad-413a-a058-db78edef2961 and b7f3df39-438c-4ec7-bd29-489f41afde14 (one or both spaces do not exist)</faultstring>
            <faultactor>http://app2101.bws.birst.com/CommandWebService.asmx</faultactor>
            <detail>
              <b:error xmlns:b="http://www.birst.com/">
                <b:message>User user@example.com failed to replicated space for b016c5c7-00ad-413a-a058-db78edef2961 and b7f3df39-438c-4ec7-bd29-489f41afde14 (one or both spaces do not exist)</b:message>
              </b:error>
            </detail>
          </soap:Fault>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def token_expiration_error
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <soap:Fault>
            <faultcode>soap:Server</faultcode>
            <faultstring>isComplete: token #{job_token} is not valid or has expired.</faultstring>
            <faultactor>http://app2101.bws.birst.com/CommandWebService.asmx</faultactor>
            <detail>
              <b:error xmlns:b="http://www.birst.com/">
                <b:message>token #{job_token} is not valid or has expired.</b:message>
              </b:error>
            </detail>
          </soap:Fault>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def server_request_error
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <soap:Fault>
            <faultcode>soap:Server</faultcode>
            <faultstring>Server was unable to process request. ---&gt; #{space_id_1}</faultstring>
            <detail/>
          </soap:Fault>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def extract_salesforce_data_response
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <extractSalesforceDataResponse xmlns="http://www.birst.com/">
            <extractSalesforceDataResult>#{job_token}</extractSalesforceDataResult>
          </extractSalesforceDataResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def problem_during_login_to_salesforce
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <extractSalesforceDataResponse xmlns="http://www.birst.com/">
            <extractSalesforceDataResult>Problem during login to Salesforce</extractSalesforceDataResult>
          </extractSalesforceDataResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def extract_connector_data
      <<-EOT.unindent
      <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://www.birst.com/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
        <env:Body>
          <tns:extractConnectorData>
            <tns:token>#{login_token}</tns:token>
            <tns:spaceID>#{space_id_1}</tns:spaceID>
            <tns:connectorName>Salesforce</tns:connectorName>
            <tns:extractGroups>
              <tns:string xsi:nil="true"/>
            </tns:extractGroups>
          </tns:extractConnectorData>
        </env:Body>
      </env:Envelope>
      EOT
    end

    def extract_connector_data_response
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <extractConnectorDataResponse xmlns="http://www.birst.com/">
            <extractConnectorDataResult>#{job_token}</extractConnectorDataResult>
          </extractConnectorDataResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end


    def publish_data_response
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <publishDataResponse xmlns="http://www.birst.com/">
            <publishDataResult>#{job_token}</publishDataResult>
          </publishDataResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def publish_is_job_complete(result=false)
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <isPublishingCompleteResponse xmlns="http://www.birst.com/">
            <isPublishingCompleteResult>#{result}</isPublishingCompleteResult>
          </isPublishingCompleteResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def publish_job_status(result="Complete")
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <getPublishingStatusResponse xmlns="http://www.birst.com/">
            <getPublishingStatusResult>
              <string>#{result}</string>
            </getPublishingStatusResult>
          </getPublishingStatusResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def swap_spaces_response
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <swapSpaceContentsResponse xmlns="http://www.birst.com/">
            <swapSpaceContentsResult>#{job_token}</swapSpaceContentsResult>
          </swapSpaceContentsResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end


    def delete_all_data_response
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <deleteAllDataFromSpaceResponse xmlns="http://www.birst.com/">
            <deleteAllDataFromSpaceResult>#{job_token}</deleteAllDataFromSpaceResult>
          </deleteAllDataFromSpaceResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def begin_data_upload
      <<-EOT.unindent
      <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://www.birst.com/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
        <env:Body>
          <tns:beginDataUpload>
            <tns:token>#{login_token}</tns:token>
            <tns:spaceID>#{space_id_1}</tns:spaceID>
            <tns:sourceName>CSV-Fiscal_Calendar</tns:sourceName>
          </tns:beginDataUpload>
        </env:Body>
      </env:Envelope>
      EOT
    end

    def begin_data_upload_response
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <beginDataUploadResponse xmlns="http://www.birst.com/">
            <beginDataUploadResult>#{job_token}</beginDataUploadResult>
          </beginDataUploadResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def set_data_upload_options
      <<-EOT.unindent
      <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://www.birst.com/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
        <env:Body>
          <tns:setDataUploadOptions>
            <tns:token>#{login_token}</tns:token>
            <tns:dataUploadToken>#{job_token}</tns:dataUploadToken>
            <tns:options>
              <tns:string>ConsolidateIdenticalStructures=false</tns:string>
            </tns:options>
          </tns:setDataUploadOptions>
        </env:Body>
      </env:Envelope>
      EOT
    end

    def set_data_upload_options_response
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <setDataUploadOptionsResponse xmlns="http://www.birst.com/"/>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def upload_data
      <<-EOT.unindent
      <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://www.birst.com/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
        <env:Body>
          <tns:uploadData>
            <tns:token>#{login_token}</tns:token>
            <tns:dataUploadToken>#{job_token}</tns:dataUploadToken>
            <tns:numBytes>4173</tns:numBytes>
            <tns:data>RmlzY2FsX0RhdGUsTFlfRmlzY2FsX0RhdGUsTFFfRmlzY2FsX0RhdGUsTE1f
      RmlzY2FsX0RhdGUsRmlzY2FsX0RheV9OdW1iZXIsRmlzY2FsX0RheV9OYW1l
      MTAsMjAxNDA0LEZZMjAxNCBRVFIgMDQsNCwyMDE0LDcK
      </tns:data>
          </tns:uploadData>
        </env:Body>
      </env:Envelope>
      EOT
    end

    def upload_data_response
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <uploadDataResponse xmlns="http://www.birst.com/"/>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def finish_data_upload
      <<-EOT.unindent
      <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://www.birst.com/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
        <env:Body>
          <tns:finishDataUpload>
            <tns:token>#{login_token}</tns:token>
            <tns:dataUploadToken>#{job_token}</tns:dataUploadToken>
          </tns:finishDataUpload>
        </env:Body>
      </env:Envelope>
      EOT
    end

    def finish_data_upload_response
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <finishDataUploadResponse xmlns="http://www.birst.com/"/>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def is_data_upload_complete
      <<-EOT.unindent
      <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://www.birst.com/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
        <env:Body>
          <tns:isDataUploadComplete>
            <tns:token>#{login_token}</tns:token>
            <tns:dataUploadToken>#{job_token}</tns:dataUploadToken>
          </tns:isDataUploadComplete>
        </env:Body>
      </env:Envelope>
      EOT
    end

    def is_data_upload_complete_response(response=true)
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <isDataUploadCompleteResponse xmlns="http://www.birst.com/">
            <isDataUploadCompleteResult>#{response}</isDataUploadCompleteResult>
          </isDataUploadCompleteResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end

    def get_data_upload_status
      <<-EOT.unindent
      <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://www.birst.com/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
        <env:Body>
          <tns:getDataUploadStatus>
            <tns:token>#{login_token}</tns:token>
            <tns:dataUploadToken>#{job_token}</tns:dataUploadToken>
          </tns:getDataUploadStatus>
        </env:Body>
      </env:Envelope>
      EOT
    end

    def get_data_upload_status_response(status)
      <<-EOT.unindent
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Body>
          <getDataUploadStatusResponse xmlns="http://www.birst.com/">
            <getDataUploadStatusResult/>
          </getDataUploadStatusResponse>
        </soap:Body>
      </soap:Envelope>
      EOT
    end
  end
end
