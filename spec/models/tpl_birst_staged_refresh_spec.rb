require 'rails_helper'

RSpec.describe TplBirstStagedRefresh, :type => :model do
  before { @tpl = FactoryGirl.create(:tpl_birst_staged_refresh) }
  subject { @tpl }

  it { should be_valid }

  it { should belong_to(:data_source_collection) }
  it { should belong_to(:birst_process_group_collection) }
  it { should belong_to(:production_space).class_name('BirstSpace') }
  it { should belong_to(:staging_space).class_name('BirstSpace') }
  it { should belong_to(:birst_extract_group_collection) }
  it { should have_one(:job_spec) }

  it { should have_many(:data_sources).through(:data_source_collection) }
  it { should have_many(:birst_process_groups).through(:birst_process_group_collection) }
  it { should have_one(:client).through(:job_spec) }
  it { should have_many(:birst_extract_groups).through(:birst_extract_group_collection) }

  context 'with a full job_spec' do
    before do
      created_template = FactoryGirl.create(:tpl_birst_staged_refresh, :with_job_spec)
      @launched_job = FactoryGirl.build(:launched_job, job_spec: created_template.job_spec)
      @launched_job.send(:initialize_job)

      # Need to reference the template instance via the launched job so it has the ability to update status
      @tpl = @launched_job.job_spec.job_template
    end

    context 'with default staging and production spaces (inherited from client)' do
      it 'returns the client production space' do
        expect(@tpl.production_space_or_default).to eq @tpl.job_spec.client.birst_spaces.where(space_type: 'production').first
      end

      it 'returns the client staging space' do
        expect(@tpl.staging_space_or_default).to eq @tpl.job_spec.client.birst_spaces.where(space_type: 'staging').first
      end
    end

    context 'with a non-default production/staging space' do
      before { @other_space = FactoryGirl.create(:birst_space, space_type: 'other') }

      it 'returns the non-default production space' do
        @tpl.production_space = @other_space
        @tpl.save!
        expect(@tpl.production_space_or_default).to eq @other_space
      end

      it 'returns the non-default staging space' do
        @tpl.staging_space = @other_space
        @tpl.save!
        expect(@tpl.staging_space_or_default).to eq @other_space
      end
    end

    describe 'running the job' do
      before do
        allow(@tpl).to receive(:delete_all_data) { 'deleting data' }
        allow(@tpl).to receive(:upload_data_sources) { 'uploading data sources' }
        allow(@tpl).to receive(:extract_space) { 'extracting space' }
        allow(@tpl).to receive(:process_space) { 'processing space' }
        allow(@tpl).to receive(:copy_space) { 'copying space' }
        allow(@tpl).to receive(:swap_spaces) { 'swapping spaces' }
      end

      let(:run_template) { @tpl.run_template }

      context 'without data sources or process groups' do
        it 'runs through all components necessary to run a staged refresh' do
          expect(@tpl).to receive(:delete_all_data)
          expect(@tpl).to receive(:upload_data_sources)
          expect(@tpl).to receive(:extract_space)
          expect(@tpl).to receive(:process_space)
          expect(@tpl).to receive(:copy_space)
          expect(@tpl).to receive(:swap_spaces)

          run_template
        end

        it 'updates the status along the way' do
          expect(@launched_job).to receive(:update).with(status_message: 'deleting all staging data')
          expect(@launched_job).to receive(:update).with(status_message: 'uploading external data')
          expect(@launched_job).to receive(:update).with(status_message: 'extracting salesforce')
          expect(@launched_job).to receive(:update).with(status_message: 'processing space')
          expect(@launched_job).to receive(:update).with(status_message: 'copying catalog to production')
          expect(@launched_job).to receive(:update).with(status_message: 'swapping staging/production')

          run_template
        end

        it 'swaps the production and staging space ids' do
          allow(@tpl).to receive(:swap_spaces) do |space_id_1, space_id_2|
            expect(space_id_1).to match BirstSpace::SPACE_UUID_REGEX
            expect(space_id_2).to match BirstSpace::SPACE_UUID_REGEX
            expect(space_id_1).to eq @tpl.production_space_or_default.space_uuid
            expect(space_id_2).to eq @tpl.staging_space_or_default.space_uuid
          end

          run_template
        end

      end

      context 'with data sources' do
        before do
          data_source_collection = FactoryGirl.create(:data_source_collection, :with_existing_sources)
          @tpl_data_sources = data_source_collection.data_sources
          @tpl.data_source_collection = data_source_collection
        end

        it 'provides an array of data sources' do
          allow(@tpl).to receive(:upload_data_sources) do |space_id, data_sources|
            expect(data_sources).to eq @tpl_data_sources.to_a
          end
          run_template
        end

        it 'sets the redshift_schema option based on the value in the related client object' do
          @tpl.client.redshift_schema = 'mytest__prod'
          
          allow(@tpl).to receive(:upload_data_sources) do |space_id, data_sources|
            expect(data_sources.select { |ds| ds.data_source_type == 'RedshiftS3DataSource' }.size).to be > 0

            data_sources.each do |ds|
              redshift_schema = ds.source_type_obj.instance_eval('@redshift_schema')
              expect(redshift_schema).to eq 'mytest__prod' if ds.data_source_type == 'RedshiftS3DataSource'
            end
          end

          run_template
        end

      end

      context 'with process groups' do
        before do
          birst_process_group_collection = FactoryGirl.create(:birst_process_group_collection, :with_existing_groups)
          @tpl_process_groups = birst_process_group_collection.birst_process_groups
          @tpl.birst_process_group_collection = birst_process_group_collection
        end

        it 'provides a list of process group names' do
          allow(@tpl).to receive(:process_space) do |space_id, process_groups: nil|
            expect(process_groups).to eq @tpl_process_groups.collect { |pg| pg.name }
          end
          run_template
        end
      end

      context 'with extract groups' do
        before do
          birst_extract_group_collection = FactoryGirl.create(:birst_extract_group_collection, :with_existing_groups)
          @tpl_extract_groups = birst_extract_group_collection.birst_extract_groups
          @tpl.birst_extract_group_collection = birst_extract_group_collection
        end

        it 'provides a list of extract group names' do
          allow(@tpl).to receive(:extract_space) do |space_id, extract_groups: nil|
            expect(extract_groups).to eq @tpl_extract_groups.collect { |pg| pg.name }
          end
          run_template
        end
      end
    end
  end
end
