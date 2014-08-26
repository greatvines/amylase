require 'rails_helper'

RSpec.describe JobSpecsController, :type => :controller do


  describe "GET #index" do
    it "builds a JSON hash object" do
      job_spec = FactoryGirl.create(:job_spec)
      get :index
      expect(assigns(:job_specs)).to eq([job_spec.as_json( { include: :job_template } )])
    end

    it "renders the index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested job_spec to @job_spec" do
      job_spec = FactoryGirl.create(:job_spec)
      get :show, id: job_spec
      expect(assigns(:job_spec)).to eq(job_spec.as_json( { include: :job_template } ))
    end

    it "renders the show view" do
      get :show, id: FactoryGirl.create(:job_spec)
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    # This probably isn't necessary.  Placeholder for any new tests.
    it "creates a new job_spec" do
      get :new
      expect(assigns(:job_spec)).to be_a JobSpec
    end
  end


  describe "POST #create" do

    context "with valid attributes" do
      it "creates a new JobSpec" do
        expect {
          post :create, job_spec: ControllerMacros.attributes_with_foreign_keys(:job_spec)
        }.to change(JobSpec, :count).by(1)
      end

      it "redirects to the created JobSpec page" do
        post :create, job_spec: ControllerMacros.attributes_with_foreign_keys(:job_spec)        
        expect(response).to redirect_to JobSpec.last
      end
    end

    context "without valid attributes" do
      # The only invalid attribute at this point is a duplicate JobSpec
      before { FactoryGirl.create(:job_spec) }

      it "does not save the new JobSpec" do
        expect {
          post :create, job_spec: ControllerMacros.attributes_with_foreign_keys(:job_spec)
        }.not_to change(JobSpec, :count)
      end

      it "re-renders the new method" do
        post :create, job_spec: ControllerMacros.attributes_with_foreign_keys(:job_spec)
        expect(response).to render_template :new
      end
    end
  end

  describe "PUT #update" do
    pending "Build some tests when I have an update controller - http://everydayrails.com/2012/04/07/testing-series-rspec-controllers.html"
  end

  describe "DELEte #destroy" do
    pending "Build some tests when I have an destroy controller - http://everydayrails.com/2012/04/07/testing-series-rspec-controllers.html"
  end
end
