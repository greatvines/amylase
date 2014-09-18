module Amylase

  # Public: Base methods needed to interface with Birst Web Services SOAP API.
  module BirstSoap

    # Public: Gets the authorization cookie
    attr_reader :auth_cookie

    # Public: Initializes any instance variables before running the job.
    #
    # Returns nothing.
    def initialize_birst_soap
      @auth_cookie = nil
      @job_log = self.launched_job.job_log
    end

    # Public: Hook that adds the initialize_birst_soap method to any class it is
    # included in.
    def self.included(klass)
      return unless klass.respond_to? :job_initializers
      klass.job_initializers << :initialize_birst_soap
    end


    # Public: Launches a Birst_Command session.  This class is needed to facilitate
    # keeping certain Birst_Command settings, like logs, common to all sessions
    # within a workflow.
    #
    # opts  - Additional options passed to a Birst_Command session block (Default: {}).
    # block - The block that is to be passed to the Birst_Command session block.
    #
    # Returns nothing.
    def birst_soap_session(opts = {}, &block)
      default_opts = { :soap_logger => @job_log }
      Session.new default_opts.merge(opts) do |bc|
        @auth_cookie = bc.auth_cookie if @auth_cookie.nil?
        block.call bc
      end
    end

    # Public: Simple job to list all spaces owned by user.
    #
    # Returns array of hashes, one element per space.
    def list_spaces
      spaces = nil
      birst_command_session do |bc|
        spaces = bc.list_spaces
      end
      spaces
    end

    # Public: Used to lookup the id for a space name for all spaces
    # owned by the user.
    #
    # Returns hash where the keys are the space names and the
    # values are the space ids.  
    def get_space_name_to_id
      my_spaces = {}
      birst_command_session do |bc|
        bc.list_spaces.each do |s|
          my_spaces[s[:name]] = s[:id]
        end
      end
      my_spaces
    end

    # Public: Used to lookup the name for a space id for all spaces
    # owned by the user.
    #
    # Returns hash where the keys are the space ids and the
    # values are the space names.  
    def get_space_id_to_name
      my_spaces = {}
      birst_command_session do |bc|
        bc.list_spaces.each do |s|
          my_spaces[s[:id]] = s[:name]
        end
      end
      my_spaces
    end


    # Public: Creates a new space.
    #
    # name     - Name of the new space.
    # comments - Optional comments/description.
    #
    # Returns the new space_id.
    def create_new_space(name, comments = "A new space")
      result = {}
      birst_command_session do |bc|
        result[:space_id] = bc.create_new_space(
          spaceName: name,
          comments:  comments,
          automatic: "false"
        )
      end

      @job_status.message = "#{result[:space_id]}"
      @job_status.data = JSON.parse(result.to_json)
      raise BWSError::BWSCreateNewSpaceError, @job_status.message unless @job_status.message =~ /^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}/

      result[:space_id]
    end


    # Public: Delete all data from space.  Only includes processed data, not
    # extracted data (there is no direct way to delete that data).
    #
    # space_id - id of the space to be deleted.
    #
    # Returns nothing.
    def delete_all_data(space_id = nil)
      result = {}

      birst_command_session do |bc|
        result[:token] = bc.delete_all_data_from_space(:spaceID => space_id)
      end

      result.merge!(wait_for_birst_job(
        complete:     :is_job_complete,
        status:       :get_job_status,
        token_name:   :jobToken,
        job_token:    result[:token],
      ))

      @job_status.message = "#{result[:status_message][:status_code]}"
      @job_status.data = JSON.parse(result.to_json)
      raise BWSError::BWSDeleteAllDataError, @job_status.message if @job_status.message != "Complete"

      nil
    end


    # Public: Extract all salesforce data.
    #
    # space_id       - id of the space to be deleted.
    # connector_name - Name of the Birst connector to extract (default: "Salesforce")
    # extract_groups - An array of group names to extract (default: nil, which extracts all).
    #
    # Returns nothing.
    def extract_space(space_id = nil, connector_name: "Salesforce", extract_groups: nil)
      result = {}

      birst_command_session do |bc|
        result[:token] = bc.extract_connector_data(
          :spaceID       => space_id,
          :connectorName => connector_name,
          :extractGroups => { "string" => extract_groups }
        )
      end

      # Returned job token must be valid
      raise result[:token] unless result[:token] =~ /^[0-9a-f]{32}$/

      result.merge!(wait_for_birst_job(
        complete:     :is_job_complete,
        status:       :get_job_status,
        token_name:   :jobToken,
        job_token:    result[:token],
      ))

      @job_status.message = "#{result[:status_message][:status_code]}"
      @job_status.data = JSON.parse(result.to_json)
      raise BWSError::BWSExtractSpaceError, @job_status.message if @job_status.message != "Complete"

      nil
    end

    # Public: Process data.
    #
    # space_id       - id of the space to be processed.
    # timestamp      - Datetime stamp to associate with the published data.
    # process_groups - An array of group names to process (Default: nil, which processes all).
    #
    # Returns nothing.
    def process_space(space_id = nil, timestamp: Time.now(), process_groups: nil)
      result = {}

      birst_command_session do |bc|
        result[:token] = bc.publish_data(
          :spaceID   => space_id,
          :date      => timestamp.strftime("%Y-%m-%dT%H:%M:%S%:z"),
          :subgroups => { "string" => process_groups }
        )
      end

      result.merge!(wait_for_birst_job(
        complete:     :is_publishing_complete,
        status:       :get_publishing_status,
        token_name:   :publishingToken,
        job_token:    result[:token],
      ))

      @job_status.message = "#{result[:status_message][:string]}"
      @job_status.data = JSON.parse(result.to_json)
      raise BWSError::BWSProcessSpaceError, @job_status.message if @job_status.message != "Complete"

      nil
    end


    # Public: Swaps the data and catalog of two spaces.
    #
    # space1_id - id of one of the spaces to swap.
    # space2_id - id of the second space to swap.
    #
    # Returns nothing
    def swap_spaces(space1_id = nil, space2_id = nil)
      result = {}

      birst_command_session do |bc|
        result[:token] = bc.swap_space_contents(:sp1ID => space1_id, :sp2ID => space2_id)
      end

      result.merge!(wait_for_birst_job(
        complete:     :is_job_complete,
        status:       :get_job_status,
        token_name:   :jobToken,
        job_token:    result[:token],
        wait_timeout: '5m'
      ))

      @job_status.message = "#{result[:status_message][:status_code]}"
      @job_status.data = JSON.parse(result.to_json)
      raise BWSError::BWSSwapSpacesError, @job_status.message if @job_status.message != "Complete"

      nil
    end


    # Public: Gets the status of a job token.
    #
    # auth_cookie   - Birst Command uthorization cookie that must be the
    #                 same as the one used to start the job (default:
    #                 the class @auth_cookie).
    # check_command - The symbol (snake_case) representing the Birst
    #                 Web Services command that is called to check the
    #                 job token.  This is usually :is_job_complete,
    #                 :get_job_status, or :is_publishing_complete.
    # token_name    - The symbol (cammelCase) representing the Birst Web
    #                 Services option to check_command that references
    #                 the job token.  This is usually :jobToken or
    #                 :publishingToken.
    # token         - The job token to be checked.
    #
    # Returns the result which may be a Booleon for :is_job_complete calls
    # or a hash for :get_job_status calls.
    def check_job_token(
      auth_cookie:   @auth_cookie,
      check_command: :is_job_complete,
      token_name:    :jobToken,
      token:         nil
    )
      result = nil
      birst_command_session do |bc|
        result = bc.send(check_command, { token_name => token })
      end

      result
    end



    # Public: Uploads a single data source to a space.
    #
    # space_id         - The space to upload the data.
    # name             - The Birst name of the target data source.
    # data_source      - A datasource object containing a description of the data
    #                    (e.g., an S3DataSource or RedshiftS3DataSource instance).
    # max_upload_retry - The maximum number of times to retry uploading a chunk of data.
    #                    Wait between retries uses exponential backoff (default: 8).
    #
    # Returns a result hash.
    def upload_data_source(space_id = nil, name = nil, data_source = nil, max_upload_retry: 8)
      result = {}
      birst_command_session do |bc|        
        result[:upload_token] = bc.begin_data_upload(
          :spaceID    => space_id,
          :sourceName => name
        )
      end

      # Required for uploading new sources per ticket #00066142
      birst_command_session do |bc|
        bc.set_data_upload_options(
          :dataUploadToken => result[:upload_token],
          :options         => { "string" => ["ConsolidateIdenticalStructures=false"] }
        )
      end


      # Data upload logs can get too large.  So create a separate logger that only
      # logs at the error level for this step.
      job_log_data = @job_log.dup

      birst_command_session :soap_logger => job_log_data, :soap_log_level => :error do |bc|
        data_source.each_chunk do |chunk|
          @job_log.debug "Uploading chunk of size #{chunk.bytesize}"

          retry_exponential_backoff max_retry: max_upload_retry do
            bc.upload_data(
              :dataUploadToken => result[:upload_token],
              :numBytes        => chunk.bytesize,
              :data            => Base64.encode64(chunk)
            )
          end
          @job_log.debug "Finished uploading chunk"
        end
      end

      birst_command_session do |bc|
        bc.finish_data_upload(:dataUploadToken => result[:upload_token])
      end

      result.merge!(wait_for_birst_job(
        complete:     :is_data_upload_complete,
        status:       :get_data_upload_status,
        token_name:   :dataUploadToken,
        job_token:    result[:upload_token],
      ))

      # I don't really know how to treat data upload errors.
      # get_data_upload_status is blank when nothing is wrong,
      # but can have lots of text warnings when there really isn't
      # any issue.
      # I'm not sure if get_job_status would work for this.
      # It gives a status result of "None" when there are no
      # errors (instead of "Complete")
      result.merge!(check_job_token(
        check_command: :get_job_status,
        token_name:    :jobToken,
        token:         result[:upload_token]
      ))

      JSON.parse(result.to_json)
    end

    # Public: Uploads an array of data sources to a Birst space.
    #
    # space_id - The space to upload the data.
    # sources  - An array of hashes that contain descriptions of the data sources.
    #            Required elements of the hash include:
    #            name:    The Birst name of the target data source.
    #            type:    The classname of the data source object (e.g., S3DataSource or RedshiftS3DataSource)
    #            options: A hash of options passed to the initialize function of
    #              the type of data source object.
    #
    # Returns nothing.
    def upload_data_sources(space_id = nil, sources = [])
      result = {}
      sources.each do |source_desc|
        # Validate sources hash
        raise "sources hash requires name, type, and options" unless ([:name, :type, :options].all? { |k| source_desc.key? k })

        data_source = GVBirstWF.const_get(source_desc[:type]).new(source_desc[:options])
        result[source_desc[:name]] = upload_data_source(space_id, source_desc[:name], data_source)
      end


      # Since I don't know how to treat data upload errors, not much I can but assume success
      @job_status.message = "Complete"
      @job_status.data = result
      raise BWSError::BWSUploadDataSourcesError, @job_status.message if @job_status.message != "Complete"

      nil
    end

    # Public: Copy space components from one space to another.
    #
    # from_id         - Space id of space to copy from.
    # to_id           - Space id of space to copy to.
    # components_keep - An array of the list of specific space
    #                   components to copy (Default: all).
    # components_drop - An array of the list of space components to
    #                   exclude from copy (Default: none).
    # mode            - Copy mode is either "copy" or "replicate" (Default: "replicate").
    # wait_timeout    - Maximum time to wait for copy command to complete
    #                   (e.g., '1m', '5h') (Default: Settings.bws_wait_timeout).
    #
    # Returns nothing.
    def copy_space(from_id: nil, to_id: nil, components_keep: nil, components_drop: [], mode: "replicate", wait_timeout: Settings.bws_wait_timeout)
      components_all = [
        "data",                 # Staging data (e.g., from CSV/SalesForce/Birst Connect)
        "datastore",            # Processed data
        "settings-permissions", # User permissions
        "settings-membership",  # User group assignments
        "repository",           # Data model & variables & more
        "birst-connect",        # Birst connect settings
        "custom-subject-areas", # All custom subject areas
        "dashboardstyles",      # Untested
        "salesforce",           # Salesforce config - will overwrite SF credentials
        "catalog",              # All report catalog
        "CustomGeoMaps.xml",    # Untested
        "spacesettings.xml",    # Untested
        "SavedExpressions.xml", # All saved expressions
        "DrillMaps.xml",        # Untested
        "connectors",           # Data connectors - essentially the same as salesforce
        "settings-basic",       # Version, etc
        "useunloadfeature"      # Set this to allow copy between spaces on different servers
      ]

      copy_components = []
      (components_all + (components_keep || [])).uniq.each do |c|
        next if components_drop.include? c
        next unless components_keep.nil? or components_keep.include? c
        copy_components << c
      end


      result = {}
      birst_command_session do |bc|
        result[:token] = bc.copy_space(
          :spFromID => from_id,
          :spToID   => to_id,
          :mode     => mode,
          :options  => copy_components.join(';')
        )
      end

      result.merge!(wait_for_birst_job(
        complete:     :is_job_complete,
        status:       :get_job_status,
        token_name:   :jobToken,
        job_token:    result[:token],
        wait_timeout: wait_timeout
      ))

      @job_status.message = "#{result[:status_message][:status_code]}"
      @job_status.data = JSON.parse(result.to_json)
      raise BWSError::BWSCopySpaceError, @job_status.message if @job_status.message != "Complete"

      nil
    end


    # Public: Wait for a birst job to complete.
    # 
    # auth_cookie    - Birst Command uthorization cookie that must be the
    #                  same as the one used to start the job (default:
    #                  the class @auth_cookie).
    # complete       - The symbol (snake_case) representing the Birst
    #                  Web Services command that is called to check if
    #                  the job is complete.  This is usually :is_job_complete
    #                  or :is_publishing_complete.
    # status         - The symbol (snake_case) representing the Birst Web
    #                  Services command that is called to check the job
    #                  status after the job has completed.This is
    #                  usually :get_job_status :get_publishing_status.
    # token_name     - The symbol (cammelCase) representing the Birst Web
    #                  Services option to check_command that references
    #                  the job token.  This is usually :jobToken or
    #                  :publishingToken.
    # job_token      - The job token to be checked.
    # wait_every     - How frequently should the status be checked
    #                  (Default: Settings.bws_wait_every).
    # wait_timeout   - The maximum time allowed for a job to run before
    #                  terminating abnormally (Default:
    #                  Settings.bws_wait_timeout).
    # wait_max_retry - Maximum number of times to retry BWS job
    #                  monitoring when encountering an unexpected
    #                  error.
    #
    # Returns a result hash.
    def wait_for_birst_job(
      auth_cookie:    @auth_cookie,
      complete:       :is_job_complete, 
      status:         :get_job_status,
      token_name:     :jobToken,
      job_token:      nil,
      wait_every:     Settings.bws_wait_every,
      wait_timeout:   Settings.bws_wait_timeout,
      wait_max_retry: Settings.bws_wait_max_retry
    )

      waiter = Rufus::Scheduler.new(:frequency => Settings.bws_wait_rufus_freq)

      def waiter.on_error(job, error)
        @job_log.error "intercepted error in #{job.id}: #{error}"
        @job_log.error "#{error.inspect}"
        @job_log.close
      end


      result = {}

      waiter_err = nil
      retry_counter = 0

      # Run the check job is complete command until it is complete
      waiter.every wait_every, :overlap => false do |job|

        begin
          save_time = Time.now()
          @job_log.debug "Checking #{complete} - #{job.count} - #{job.threads}"
          @job_log.debug "retry_counter: #{retry_counter}"
          @job_log.debug "#{complete}, #{token_name}, #{job_token}"
          is_complete = check_job_token(check_command: complete, token_name: token_name, token: job_token)
          @job_log.debug "is_complete = #{is_complete} - #{Time.now() - save_time}"

          waiter.shutdown if is_complete

          # Retry counter is reset if all above complete without error
          retry_counter = 0


        rescue StandardError => err
          @job_log.warn "Error detected, possibly recoverable - #{err.class.name} - #{err}"
          @job_log.warn "#{$!}\n\t#{err.backtrace.join("\n\t")}"

          bws_err = BWSError.parse_soap_fault(err)
          puts "BWS_ERR: #{bws_err.class}"


          # Some errors get shut down immediately
          if [GVBirstWF::BWSError::BWSInvalidTokenError].include? bws_err.class
            @job_log.error "Fatal error detected: #{bws_err.class.name}: #{bws_err}"

            waiter_err = bws_err
            waiter.shutdown
          end

          # All other errors retry
          retry_counter += 1
          if retry_counter > wait_max_retry
            @job_log.error "#{bws_err}"
            @job_log.error "Retry exceeded"
            waiter_err = bws_err
            waiter.shutdown
          else
            @job_log.warn "#{bws_err}"
            @job_log.warn "Will retry #{retry_counter}/#{wait_max_retry}"
          end
        end
      end
      

      # Launch a job that stops Rufus if job has been running too long
      waiter.in wait_timeout, :blocking => true, :overlap => false do
        begin
          waiter_err = BWSError::BWSWaitTimeoutError.new "Birst job wait timed out after #{wait_timeout}"
          @job_log.error waiter_err
        ensure
          waiter.shutdown
        end
      end

      waiter.join


      # Re-raise any errors that might have happened during the wait task
      raise waiter_err unless waiter_err.nil?

      result[:status_message] = check_job_token(
        check_command: status,
        token_name:    token_name,
        token:         job_token
      )

      result
    end

  end
end
