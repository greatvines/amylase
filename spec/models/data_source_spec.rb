require 'rails_helper'

RSpec.describe DataSource, :type => :model do

  before { @data_source = FactoryGirl.create(:data_source) }
  subject { @data_source }

  it { should respond_to(:name) }
  it { should respond_to(:birst_filename) }
  it { should respond_to(:data_source_type) }
  it { should respond_to(:redshift_sql) }
  it { should respond_to(:s3_path) }
  it { should be_valid }

  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:data_source_type) }

  it { should allow_value('s3://mybucket/something.csv').for(:s3_path) }
  it { should allow_value('s3://mybucket/dir/some thi-ng.csv').for(:s3_path) }
  it { should_not allow_value('s3://myb ucket/something.csv').for(:s3_path) }
  it { should_not allow_value('dir/something.csv').for(:s3_path) }

  it { should validate_inclusion_of(:data_source_type).in_array(DataSource::DATA_SOURCE_TYPES) }

  it { should have_many(:data_source_collection_associations).dependent(:destroy) }
  it { should have_many(:data_sources).through(:data_source_collection_associations) }


  context 'if RedshiftS3DataSource' do
    before { allow(subject).to receive(:data_source_type) { 'RedshiftS3DataSource' } }
    it { should validate_presence_of(:redshift_sql) }
  end

  context 'if S3DataSource' do
    before { allow(subject).to receive(:data_source_type) { 'S3DataSource' } }
    it { should validate_presence_of(:s3_path) }
  end

  context 'extracting s3 data', :live => true do
    before do
      Settings.data_sources.max_chunk_size = 10

      # Write a random file with a known size to S3
      @dummy_rows = 1000
      @dummy_length = 80
      s3_bucket = AWS::S3.new.buckets[Settings.test.s3_file[/s3:\/\/([\w-]+)\//,1]]
      s3_obj = s3_bucket.objects[Settings.test.s3_file[/s3:\/\/[\w-]+\/(.*)/,1]]
      s3_obj.write(@dummy_rows.times.collect { SecureRandom.hex(@dummy_length) }.join("\n"))

      @s3_data_source = FactoryGirl.create(:data_source, :s3_data_source)
    end

    after { Settings.reload! }

    it 'reads all of the expected data' do
      expect(@s3_data_source.chunks.inject(0) { |sum, chunk| sum + chunk.bytesize }).to eq 2 * (@dummy_rows * @dummy_length) + (@dummy_rows - 1)
    end

    it 'returns multiple chunks' do
      expect(@s3_data_source.chunks.count).to be > 1
    end
  end

  context 'extracting Redshift data', :live => true do
    before do
      @redshift_s3_data_source = FactoryGirl.build(:data_source, :redshift_s3_data_source)

      # Modify the query to contain a total row count.  This enables
      # us to validate row counts without having a known static table.
      orig_query = @redshift_s3_data_source.redshift_sql
      modified_query = <<-EOF.unindent
      select total.cnt, detail.*
      from
        (select count(*) as cnt from (#{orig_query})) total
      inner join
        (#{orig_query}) detail
      on
        true
      EOF

      @redshift_s3_data_source.redshift_sql = modified_query
      @redshift_s3_data_source.save!
      @redshift_s3_data_source.initialize_data_source_type(redshift_schema: Settings.test.redshift_schema)
    end

    it 'returns as many rows as generated' do
      result = @redshift_s3_data_source.chunks.inject('') { |result,chunk| result << chunk }.lines
      expect(result.count - 1).to eq result[1].split('|')[0].to_i
    end

    it 'cleans up the staging folder' do
      @redshift_s3_data_source.chunks.each { |x| nil }
      s3_bucket = @redshift_s3_data_source.source_type_obj.instance_variable_get("@s3_bucket")
      s3_table_folder = @redshift_s3_data_source.source_type_obj.instance_variable_get("@s3_table_folder")

      expect(s3_bucket.objects.with_prefix(s3_table_folder).count).to be 0
    end

  end

end
