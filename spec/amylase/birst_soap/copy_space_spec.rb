require 'rails_helper'

describe "Copying a space", skip: "not yet" do
  include BirstSoapSupport

  before do
    Settings.bws_wait_timeout = '10s'
    Settings.bws_wait_every = '0.3s'

    savon.mock!
    mock_login_and_out do 
      savon.expects(:copy_space)
        .with(message: BCSpecFixtures.copy_space_message)
        .returns(BCSpecFixtures.copy_space)
    end

    # Mock two incompletes before completing
    mock_is_job_complete(false,2)
    mock_is_job_complete(true)
    mock_job_status("Complete")
  end

  after { savon.unmock! }



  context "using the copy space primitive" do
    it "should be successful" do
      job = JobTemplate.new
      job.copy_space(
        from_id:         BCSpecFixtures.space_id_1,
        to_id:           BCSpecFixtures.space_id_2,
        mode:            "replicate",
        components_keep: ["data","datastore"]
      )
    end
  end

  context "using an instance of the copy space job template" do
    
    it "should be successful" do
      job = CopySpaceTemplate.new(args: { from_space_id: BCSpecFixtures.space_id_1, to_space_id: BCSpecFixtures.space_id_2, components_keep: ["data","datastore"] })
      job.do_work
    end

  end

end

