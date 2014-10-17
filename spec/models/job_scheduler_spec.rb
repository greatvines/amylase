require 'rails_helper'

RSpec.describe JobScheduler, :type => :model do
  before { @job_scheduler = JobScheduler.new timeout: 2 }
  after { @job_scheduler.destroy }
  subject { @job_scheduler }

  it { should respond_to(:timeout) }
  it { should respond_to(:running) }
  it { should respond_to(:started_at) }
  it { should respond_to(:uptime) }
  it { should respond_to(:threads) }
  it { should respond_to(:jobs) }
  it { should be_valid }

  it "only allows one instance at a time" do
    another_scheduler = JobScheduler.new
    expect(another_scheduler).to eq @job_scheduler
  end

  it "starts up and shuts down" do
    expect(@job_scheduler.running).to be false

    @job_scheduler.start_scheduler

    expect(@job_scheduler.running).to be true
    expect(@job_scheduler.started_at).not_to be nil
    expect(@job_scheduler.uptime).not_to be nil
    expect(@job_scheduler.threads).not_to be nil
    expect(@job_scheduler.jobs).not_to be_empty

    @job_scheduler.wait_for_shutdown

    expect(@job_scheduler.running).to be false
  end


  context "with a job to schedule", :rufus_job => true do
    before do 
      @job_spec = FactoryGirl.create(:job_spec, :schedule_interval_1s, name: "MyTestSpec", enabled: true)
      FactoryGirl.create_list(:job_spec, 2, :schedule_in_1s, enabled: true)
      FactoryGirl.create_list(:job_spec, 3, :schedule_in_1s, enabled: false)

      @job_scheduler.start_scheduler
    end
    after { @job_scheduler.destroy }


    it "schedules JobSpecs that are enabled" do
      enabled = JobSpec.where(enabled: true).collect { |j| j.name }

      scheduled = @job_scheduler.jobs.collect do |j|
        j[:job_spec_name] if j[:job_spec_name] != "SchedulerTimeout"
      end.compact

      expect(scheduled).to match_array enabled
    end


    it "runs a JobSpec that is enabled" do
      last_time = lambda { @job_scheduler.jobs.select { |j| j[:job_spec_name] == "MyTestSpec" }.pop[:last_time] }

      expect(last_time.call).to be_nil
      @job_scheduler.wait_for_shutdown
      expect(last_time.call).to be_a(Time)
    end

    it 'can unschedule a job_spec' do
      @job_scheduler.unschedule_job_spec(@job_spec)
      expect(@job_scheduler.jobs.collect { |j| j[:job_spec_name] }).not_to include 'MyTestSpec'
    end

  end
end
