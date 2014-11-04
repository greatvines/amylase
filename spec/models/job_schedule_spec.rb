require 'rails_helper'

RSpec.describe JobSchedule, :type => :model do

  before { @job_schedule = FactoryGirl.create(:job_schedule) }
  subject { @job_schedule }

  it { should respond_to(:job_schedule_group_id) }
  it { should respond_to(:schedule_method) }
  it { should respond_to(:schedule_time) }
  it { should respond_to(:first_at) }
  it { should respond_to(:last_at) }
  it { should respond_to(:number_of_times) }

  it { should validate_presence_of(:job_schedule_group) }
  it { should validate_presence_of(:schedule_method) }
  it { should validate_presence_of(:schedule_time) }

  it { should belong_to(:job_schedule_group) }

  it { should validate_inclusion_of(:schedule_method).in_array(JobSchedule::SCHEDULE_METHODS) }

  [:first_at, :last_at, :schedule_time].each do |field|
    it { should allow_value('2014-09-14 18:22:00 Asia/Shanghai').for(field) }
    it { should allow_value('2014-09-14 18:22:00 -0700').for(field) }
    it { should allow_value('2014-09-14 18:22:00').for(field) }
    it { should_not allow_value('2014-09-14 28:22:00').for(field) }
    it { should_not allow_value('2014-13-10 18:22:00').for(field) }
    it { should_not allow_value('09/14/2014 18:22:00').for(field) }
  end

  it { should allow_value('2h').for(:schedule_time) }
  it { should allow_value('* 01 * * * America/Los_Angeles').for(:schedule_time) }
  it { should_not allow_value('* 01 * *').for(:schedule_time) }

  [:first_at, :last_at].each do |field|
    it { should_not allow_value('* 01 * * *').for(field) }
    it { should_not allow_value('1h').for(field) }
  end

  it { should be_valid }

  describe 'rufus options' do
    shared_examples 'rufus non-blank options' do
      it 'only returns non-blank options' do
        subject.rufus_options.each do |k,v|
          expect(v).to_not be_blank
        end
      end
    end

    shared_examples 'a non-skipped schedule' do
      it 'does not include the skip option' do
        expect(subject.rufus_options.keys).not_to include :_skip
      end
    end

    context 'base model' do
      it_behaves_like 'rufus non-blank options'
      it_behaves_like 'a non-skipped schedule'
    end

    context 'with first_at populated in the future' do
      before { @job_schedule.first_at = (Time.now + 1.hour).strftime('%Y-%m-%d %H:%M:%S') }
      it_behaves_like 'rufus non-blank options'
      it_behaves_like 'a non-skipped schedule'
    end

    context 'with last_at populated in the future' do
      before { @job_schedule.last_at = (Time.now + 1.hour).strftime('%Y-%m-%d %H:%M:%S') }
      it_behaves_like 'rufus non-blank options'
      it_behaves_like 'a non-skipped schedule'
    end

    context 'with first_at populated in the past' do
      before { @job_schedule.first_at = (Time.now - 1.hour).strftime('%Y-%m-%d %H:%M:%S') }
      it_behaves_like 'a non-skipped schedule'

      it 'should not return the first_at option' do
        expect(@job_schedule.rufus_options.keys).not_to include :first_at
      end
    end

    context 'with last_at populated in the past' do
      before { @job_schedule.last_at = (Time.now - 1.hour).strftime('%Y-%m-%d %H:%M:%S') }
      it_behaves_like 'rufus non-blank options'

      it 'includes the skip option' do
        expect(@job_schedule.rufus_options.keys).to include :_skip
      end
    end
  end

end
