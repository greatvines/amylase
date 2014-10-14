require 'rails_helper'

describe 'Uploading data sources' do
  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  include BirstSoapSupport

  before do
    Settings.birst_soap.wait.timeout = '5s'
    Settings.birst_soap.wait.every = '0.3s'
    Settings.birst_soap.rufus_freq = '0.1s'
  end

  after { Settings.reload! }

  # I'm not smart enough to figure out a good mock test for this, so I'll do it live
  context 'successful data upload cycle', :live => true do
    before { @space_id = create_new_space("_Amylase-Spec-#{SecureRandom.hex(4)}").result_data }
    after { delete_space(@space_id) }

    it 'uploads data' do
      data_source = FactoryGirl.build(:data_source, :s3_data_source)

      s3_bucket = AWS::S3.new.buckets[Settings.test.s3_file[/s3:\/\/([\w-]+)\//,1]]
      s3_obj = s3_bucket.objects[Settings.test.s3_file[/s3:\/\/[\w-]+\/(.*)/,1]]
      s3_obj.write(<<-EOF.unindent
      col1, col2, col3
      A, B, C
      X, Y, Z
      EOF
      )

      upload_data_source(@space_id, data_source)
    end

  end
end

