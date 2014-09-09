require 'rails_helper'

RSpec.describe JobScheduler, :type => :model do
  before { @job_scheduler = JobScheduler.new timeout: 1 }
  after { @job_scheduler.destroy }
  subject { @job_scheduler }

  it { should respond_to(:timeout) }
  it { should respond_to(:running) }
  it { should respond_to(:started_at) }
  it { should respond_to(:uptime) }
  it { should respond_to(:threads) }
  it { should respond_to(:job_list) }
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
    expect(@job_scheduler.job_list).not_to be_empty
    
    @job_scheduler.wait_for_shutdown
    expect(@job_scheduler.running).to be false
  end


  context "with a job to schedule" do
    before do 
      FactoryGirl.create(:job_spec, enabled: true)
      @job_scheduler.start_scheduler
    end
    after { @job_scheduler.destroy }

    it "schedules JobSpecs that are enabled" do
      puts @job_scheduler.job_list.to_yaml
    end


    it "runs a JobSpec that is enabled and returns a result" do
    end
  end
end
