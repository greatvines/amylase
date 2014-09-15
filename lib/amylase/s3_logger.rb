module Amylase

  # Public: IO Class for logging output to S3.  Objects in this class
  # are intended to be used as the IO object for Logger objects.  The
  # aws-sdk gem is required.  max_log_lines lines are buffered in
  # memory until a write to S3 is performed.  A call to the close method
  # is required to write any remaining log lines left in the buffer.
  #
  # Example
  #    logger = Logger.new(S3Logger.new("mybucket", "logs/mylogger"))
  #    logger.error "This is an error message"
  #    logger.close
  class S3Logger

    # Public: Initializes an S3Logger object.
    #
    # bucket_name   - Name of s3 bucket to store logs.
    # log_base_name - Base name of logger file (appended with timestamp and UUID).
    # max_log_lines - Optionally change the maximum log lines per file (Default: Settings.max_log_lines).
    #
    # Returns an S3Logger object
    def initialize(bucket_name, log_base_name, max_log_lines: Settings.max_log_lines)
      @s3_bucket = AWS::S3.new.buckets[bucket_name]
      @log_base_name = log_base_name
      @max_log_lines = max_log_lines

      @uuid = UUID.new.generate

      @log_number = 0
      new_log_buffer
    end

    # Public: Write data to both standard output and the S3 log.
    #
    # data - A string to write to the log.
    #
    # Returns nothing.
    def write(data)
      @log_buffer.write(data)
      puts data
      @log_lines += 1
      log_to_s3 if @log_lines >= @max_log_lines
    end

    # Public: Convert current log buffer to a string.
    #
    # Returns a string with the log buffer.
    def to_s
      @log_buffer.string
    end

    # Public: Close the IO object.
    #
    # Returns nothing.
    def close
      log_to_s3
    end



    private

    # Private: Create the name of the log file.
    #
    # Returns a string with the full log file name.
    def log_name
      "logs/#{Time.now.strftime('%Y%m%d')}/#{Settings.environment}-#{@log_base_name}-#{Time.now.strftime('%Y%m%d-%H%M%S%z')}-#{@uuid}-#{'%05d' % @log_number}.log"
    end

    # Private: Create a new log buffer.
    #
    # Returns nothing.
    def new_log_buffer
      @log_lines = 0
      @log_number += 1
      @log_buffer = StringIO.new
      @s3_obj = @s3_bucket.objects[log_name]
    end

    # Private: Log the current buffer to an S3 log file
    #
    # Returns nothing.
    def log_to_s3
      @s3_obj.write(to_s)
      new_log_buffer
    end
  end
end
