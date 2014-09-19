require 'rails_helper'

describe "Copying a space" do
  extend Amylase::JobInitializers
  include Amylase::BirstSoap
  include BirstSoapSupport

  before do
    savon.mock!
    Settings.birst_soap.wait.timeout = '5s'
    Settings.birst_soap.wait.every = '0.3s'
    Settings.birst_soap.rufus_freq = '0.1s'
  end

  after { savon.unmock! }

  context "successful copy, wait, complete cycle" do
    before do
      mock_login_and_out do 
        savon.expects(:copy_space)
          .with(message: BirstSoapFixtures.copy_space_message)
          .returns(BirstSoapFixtures.copy_space_response)
      end

      # Mock two incompletes before completing
      mock_is_job_complete(false,2)
      mock_is_job_complete(true)
      mock_job_status("Complete")
    end

    it "completes successfully" do
      expect(
        copy_space(
          from_id:         BirstSoapFixtures.space_id_1,
          to_id:           BirstSoapFixtures.space_id_2,
          mode:            "replicate",
          components_keep: ["data","datastore"]
        ).result_data[:final_status][:status_code]
      ).to eq "Complete"
    end
  end

  context "selecting space components to include/exclude" do

    it "includes all components by default" do
      mock_login_and_out do 
        savon.expects(:copy_space)
          .with(message: BirstSoapFixtures.copy_space_message(options: Amylase::BirstSoap::ALL_COPY_COMPONENTS.join(';')))
          .returns(BirstSoapFixtures.copy_space_response)
      end
      mock_is_job_complete(true)
      mock_job_status("Complete")

      copy_space(
        from_id:         BirstSoapFixtures.space_id_1,
        to_id:           BirstSoapFixtures.space_id_2,
        mode:            "replicate"
      )
    end
      
    it "keeps only selected components from the list" do
      mock_login_and_out do 
        savon.expects(:copy_space)
          .with(message: BirstSoapFixtures.copy_space_message(options: "data;catalog;salesforce"))
          .returns(BirstSoapFixtures.copy_space_response)
      end
      mock_is_job_complete(true)
      mock_job_status("Complete")

      copy_space(
        from_id:         BirstSoapFixtures.space_id_1,
        to_id:           BirstSoapFixtures.space_id_2,
        mode:            "replicate",
        components_keep: ["data", "catalog", "salesforce"]
      )
    end

    it "keeps listed components not in the list" do
      mock_login_and_out do 
        savon.expects(:copy_space)
          .with(message: BirstSoapFixtures.copy_space_message(options: "data;catalog:shared/GreatVines Package"))
          .returns(BirstSoapFixtures.copy_space_response)
      end
      mock_is_job_complete(true)
      mock_job_status("Complete")

      copy_space(
        from_id:         BirstSoapFixtures.space_id_1,
        to_id:           BirstSoapFixtures.space_id_2,
        mode:            "replicate",
        components_keep: ["data", "catalog:shared/GreatVines Package"]
      )
    end

    it "drops components in the drop list" do
      mock_login_and_out do 
        savon.expects(:copy_space)
          .with(message: BirstSoapFixtures.copy_space_message(options: (Amylase::BirstSoap::ALL_COPY_COMPONENTS - ["data", "datastore"]).join(';')))
          .returns(BirstSoapFixtures.copy_space_response)
      end
      mock_is_job_complete(true)
      mock_job_status("Complete")

      copy_space(
        from_id:         BirstSoapFixtures.space_id_1,
        to_id:           BirstSoapFixtures.space_id_2,
        mode:            "replicate",
        components_drop: ["data", "datastore", "alphabet"]
      )
    end

  end


end

