# Public: Describes remote S3 data sources.
class S3DataSource < DataSource

  # Gets the parent DataSource object.
  attr_reader :data_source

  # Public: Initializes an S3 data source.
  #
  # data_source - The parent DataSource object.
  def initialize(data_source, *opts)
    @data_source = data_source
    @s3_bucket = AWS::S3.new.buckets[@data_source.s3_path[/s3:\/\/([\w-]+)\//,1]]
    @s3_obj = @s3_bucket.objects[@data_source.s3_path[/s3:\/\/[\w-]+\/(.*)/,1]]
  end

  # Public: Reads an S3 objects.
  #
  # block - A block containing commands used to manipulate the yielded data.
  #
  # Examples
  #   source = S3DataSource.new(data_source)
  #   source.each_chunk do |chunk|
  #     print chunk
  #   end
  #
  # Yields a chunk of data returned from S3.
  def read(&block)
    Dir.mktmpdir(File.join("Amylase-#{UUID.new.generate}"), Dir.tmpdir) do |tmpdir|
      tmp_filename = File.join(tmpdir, @data_source.name)

      File.open(tmp_filename, 'wb') do |file|
        @s3_obj.read do |chunk|
          file.write(chunk)
        end
      end

      File.open(tmp_filename) do |file|
        file.each_line do |line|
          yield line
        end
      end
    end
  end
end
