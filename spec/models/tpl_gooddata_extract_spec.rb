require 'rails_helper'

RSpec.describe TplGooddataExtract, :type => :model do
  before { @tpl = FactoryGirl.create(:tpl_gooddata_extract) }
  subject { @tpl }

  it { should respond_to(:destination_path) }
  it { should respond_to(:append_timestamp) }
  it { should be_valid }

  it { should belong_to(:gooddata_project) }
  it { should belong_to(:destination_credential).class_name('ExternalCredential') }
  it { should have_one(:job_spec) }

  it { should have_one(:client).through(:job_spec) }

  it { should have_many(:tpl_gooddata_extract_reports).dependent(:destroy) }
  it { should accept_nested_attributes_for(:tpl_gooddata_extract_reports) }

  it { should allow_value('ftp://example.com/reports/somefile.zip').for(:destination_path) }
  it { should allow_value('ftp://example.com/reports/').for(:destination_path) }
  it { should_not allow_value('ftp://example.com/reports/somefile.csv').for(:destination_path) }
  it { should_not allow_value('ftp://example.com/reports').for(:destination_path) }

  it 'accepts nested attributes for repots via a jobspec' do
    params = {
      name: 'DummyJobSpec',
      job_template_type: 'TplGooddataExtract',
      job_template_attributes: {
        gooddata_project_id: 1,
        destination_path: 'ftp://example.com/reports.zip',
        tpl_gooddata_extract_reports_attributes: {
          one: {
            name: 'depletions',
            report_oid: '12345',
            destination_file_name: 'depletions.csv',
            export_method: 'executed'
          },
          two: {
            name: 'sales',
            report_oid: '98765',
            destination_file_name: 'sales.csv',
            export_method: 'raw'
          }
        }
      }
    }

    JobSpec.create!(params)

    job_spec = JobSpec.where(name: 'DummyJobSpec').take

    expect(job_spec.job_template.tpl_gooddata_extract_reports.size).to eq 2

    rpt_names = job_spec.job_template.tpl_gooddata_extract_reports.collect { |rpt| rpt.name }
    expect(rpt_names).to match_array ['sales', 'depletions']
  end

  describe 'with_timestamp' do
    let(:file_name) { 'ftp://examle.com/myfile.zip' }

    context 'append_timestamp is true' do
      before { @tpl.append_timestamp = true }
      it 'appends a timestamp' do
        ext = Pathname(file_name).extname.to_s
        expect(@tpl.with_timestamp(file_name)).to match /.*-\d{8}_\d{6}#{ext}\Z/
      end
    end

    context 'append_timestamp is false' do
      before { @tpl.append_timestamp = false }
      it 'does not append a timestamp' do
        ext = Pathname(file_name).extname.to_s
        expect(@tpl.with_timestamp(file_name)).not_to match /.*-\d{8}_\d{6}#{ext}\Z/
      end
    end
  end

  describe 'destination_path' do
    before { @destination_path_ex = 'ftp://example.com/reports/' }

    shared_examples 'destination_path components' do
      it 'provides the destination host' do
        expect(@tpl.destination_host).to eq 'example.com'
      end

      it 'provides the destination folder' do
        expect(@tpl.destination_folder).to eq '/reports/'
      end

      it 'provides the destination scheme' do
        expect(@tpl.destination_scheme).to eq 'ftp'
      end
    end

    context 'a folder' do
      before { @tpl.destination_path = @destination_path_ex }

      it 'is a folder_container' do
        expect(@tpl.folder_container?).to be_truthy
      end

      it 'is a not zip_container' do
        expect(@tpl.zip_container?).to be_falsey
      end

      it_behaves_like 'destination_path components'
    end

    context 'a zip file' do
      before { @tpl.destination_path = File.join(@destination_path_ex, 'somefile.zip') }

      it 'is a zip_container' do
        expect(@tpl.zip_container?).to be_truthy
      end

      it 'is not a folder container' do
        expect(@tpl.folder_container?).to be_falsey
      end

      it 'has the expected zip_name' do
        expect(@tpl.zip_name).to eq 'somefile.zip'
      end

      it_behaves_like 'destination_path components'
    end
  end


  context 'with a full job_spec', :gooddata_rest_mock do
    before do
      FactoryGirl.create(:external_credential, :gooddata_admin)
      tpl_gooddata_extract = FactoryGirl.create(:tpl_gooddata_extract, :with_full_job_spec)
      @launched_job = FactoryGirl.create(:launched_job, job_spec: tpl_gooddata_extract.job_spec)
      @launched_job.send(:initialize_job)

      # Need to reference the template instance via the launched job so it has the ability to update status
      @tpl = @launched_job.job_spec.job_template
    end

    it 'can access the GooddataAdmin credentials' do
      expect { @tpl.send(:get_rest_credentials) }.not_to raise_error
    end

    it 'is associated with a valid Gooddata pid' do
      expect(@tpl.gooddata_project.project_uid).to match GooddataProject::PID_REGEX
    end

    it 'is associated with a valid Gooddata pid again' do
      expect(@tpl.gooddata_project.project_uid).to match GooddataProject::PID_REGEX
    end

    context 'with Gooddata REST queries', :gooddata_rest_mock do
      include GooddataRestSupport

      before do
        credentials = @tpl.send(:get_rest_credentials)
        @stub_username = credentials.username
        @stub_password = credentials.password
        @stub_pid = @tpl.gooddata_project.project_uid

        stub_post_gdc_account_login
        stub_get_gdc_account_token
      end

      it 'can log in to Gooddata' do
        @tpl.send(:establish_gooddata_connection)

        expect(stub_post_gdc_account_login).to have_been_requested
        expect(stub_get_gdc_account_token).to have_been_requested
      end

      context 'exporting reports to local temp files' do
        before do
          @dummy_report_oid = @tpl.tpl_gooddata_extract_reports.take.report_oid
          stub_post_gdc_xtab2_executor3(@dummy_report_oid)
          stub_post_gdc_exporter_executor
          stub_download_uri_executed

          stub_post_gdc_app_projects_pid_execute_raw(@dummy_report_oid)
          stub_download_uri_raw

          conn = @tpl.send(:establish_gooddata_connection)
          @exported_files = @tpl.send(:export_reports, conn)
        end

        it 'can download each report from Gooddata' do
          # The factory includes one executed and one raw report.
          expect(stub_post_gdc_xtab2_executor3(@dummy_report_oid)).to have_been_requested.once
          expect(stub_post_gdc_exporter_executor).to have_been_requested.once

          expect(stub_post_gdc_app_projects_pid_execute_raw(@dummy_report_oid)).to have_been_requested.once
        end

        it 'exports each report to a local temp file' do
          @tpl.tpl_gooddata_extract_reports.each do |rpt|
            case rpt.export_method
            when 'executed'
              expect(@exported_files[rpt.destination_file_name].read).to eq stub_download_data_executed_plaintext
            when 'raw'
              expect(@exported_files[rpt.destination_file_name].read).to eq stub_download_data_raw_plaintext
            end
          end
        end

        context 'collecting reports as a zip file' do
          before do
            @tpl.destination_path = 'ftp://example.com/myfile.zip'
            @collected_reports = @tpl.send(:collect_reports, @exported_files)
          end

          it 'collects all of the expected reports in a zip file' do
            zipped_files = []
            Zip::File.open(@collected_reports[@tpl.zip_name].path) do |zipfile|
              zipped_files = zipfile.collect { |entry| entry.name }
            end

            expect(zipped_files).to match_array @tpl.tpl_gooddata_extract_reports.collect { |rpt| rpt.destination_file_name }
          end
        end

        context 'collecting reports as a set of raw files' do
          before do
            @tpl.destination_path = 'ftp://example.com/'
            @collected_reports = @tpl.send(:collect_reports, @exported_files)
          end

          it 'collects all of the expected reports in raw files' do
            expect(@collected_reports.keys).to match_array @tpl.tpl_gooddata_extract_reports.collect { |rpt| rpt.destination_file_name }
          end
        end
      end
    end

    context 'transferring files to a remote ftp server' do
      before do
        @files_hash = {
          'myreport.csv' => '/var/tmp/lv/myreport.csv38656fhfd8a',
          'myreport_other.csv' => '/var/tmp/lv/myreport_other.csv3397t7g'
        }
      end

      it 'makes all of the appropriate ftp calls' do
        ftp = double('Ftp server', :null_object => true)
        expect(Net::FTP).to receive(:open).once.and_yield(ftp)
        expect(ftp).to receive(:login).once.with(@tpl.destination_credential.username, @tpl.destination_credential.password)
        expect(ftp).to receive(:passive=).once.with(true)
        expect(ftp).to receive(:chdir).once.with(@tpl.destination_folder)
        @files_hash.each do |remote_file, local_file|
          expect(ftp).to receive(:putbinaryfile).with(local_file, @tpl.with_timestamp(remote_file))
        end

        @tpl.send(:transfer_reports_to_ftp, @files_hash)
      end
    end

    context 'executing the template job' do
      before do
        allow(@tpl).to receive(:establish_gooddata_connection) { 'establish_gooddata_connection' }
        allow(@tpl).to receive(:export_reports) { 'export_reports' }
        allow(@tpl).to receive(:collect_reports) { 'collect_reports' }
        allow(@tpl).to receive(:transfer_reports_to_ftp) { 'transfer_reports_to_ftp' }
      end

      it 'runs through all components necessary to run the job' do
        expect(@tpl).to receive(:establish_gooddata_connection)
        expect(@tpl).to receive(:export_reports)
        expect(@tpl).to receive(:collect_reports)
        expect(@tpl).to receive(:transfer_reports_to_ftp)

        @tpl.run_template
      end
    end

  end
end
