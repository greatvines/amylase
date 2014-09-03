require 'rails_helper'

RSpec.describe JobSpecsController, :type => :controller do

  let(:valid_attributes) { ControllerMacros.attributes_with_foreign_keys(:job_spec) }
  let(:invalid_attributes) { ControllerMacros.attributes_with_foreign_keys(:job_spec) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # JobSpecsController. Be sure to keep this updated too.
  let(:valid_session) { {} }


  describe "GET index" do
    it "assigns all job_specs as @job_specs" do
      job_spec = JobSpec.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:job_specs)).to eq([job_spec])
    end

    it "renders the index view" do
      get :index, {}, valid_session
      expect(response).to render_template :index
    end
  end

  describe "GET show" do
    it "assigns the requested job_spec as @job_spec" do
      job_spec = JobSpec.create! valid_attributes
      get :show, { id: job_spec }, valid_session
      expect(assigns(:job_spec)).to eq(job_spec)
    end

    it "renders the show view" do
      get :show, { id: (JobSpec.create! valid_attributes) }, valid_session
      expect(response).to render_template :show
    end
  end

  describe "GET new" do
    it "assigns a new job_spec as @job_spec" do
      get :new, {}, valid_session
      expect(assigns(:job_spec)).to be_a_new(JobSpec)
    end
  end

  describe "GET edit" do
    it "assigns the requested job_spec as @job_spec" do
      job_spec = JobSpec.create! valid_attributes
      get :edit, { id: job_spec.to_param }, valid_session
      expect(assigns(:job_spec)).to eq(job_spec)
    end
  end



  describe "POST create" do
    context "with valid parrams" do
      it "creates a new JobSpec" do
        expect {
          post :create, { job_spec: valid_attributes }, valid_session
        }.to change(JobSpec, :count).by(1)
      end

      it "assigns a newly created job_spec as @job_spec" do
        post :create, { job_spec: valid_attributes }, valid_session
        expect(assigns(:job_spec)).to be_a(JobSpec)
        expect(assigns(:job_spec)).to be_persisted
      end

      it "redirects to the created job_spec" do
        post :create, { job_spec: valid_attributes }, valid_session
        expect(response).to redirect_to JobSpec.last
      end
    end

    context "with invalid params" do
      # The only invalid attribute at this point is a duplicate JobSpec
      before { JobSpec.create! valid_attributes }

      it "does not save the new JobSpec" do
        expect {
          post :create, job_spec: invalid_attributes
        }.not_to change(JobSpec, :count)
      end

      it "re-renders the new method" do
        post :create, job_spec: invalid_attributes
        expect(response).to render_template :new
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        valid_attributes.merge('enabled' => !valid_attributes[:enabled])
      }

      it "updates the requested job_spec" do
        job_spec = JobSpec.create! valid_attributes
        put :update, {:id => job_spec.to_param, :job_spec => new_attributes}, valid_session
        job_spec.reload
        expect(job_spec.enabled).to be !valid_attributes[:enabled]
      end

      it "assigns the requested job_spec as @job_spec" do
        job_spec = JobSpec.create! valid_attributes
        put :update, {:id => job_spec.to_param, :job_spec => valid_attributes}, valid_session
        expect(assigns(:job_spec)).to eq(job_spec)
      end

      it "redirects to the job_spec" do
        job_spec = JobSpec.create! valid_attributes
        put :update, {:id => job_spec.to_param, :job_spec => valid_attributes}, valid_session
        expect(response).to redirect_to(job_spec)
      end
    end

    describe "with invalid params" do
      # The only invalid attribute at this point is a duplicate JobSpec
      before { JobSpec.create! valid_attributes.merge('name' => 'existing_job_spec') }
      let(:invalid_attributes) { valid_attributes.merge('name' => 'existing_job_spec') }

      it "assigns the job_spec as @job_spec" do
        job_spec = JobSpec.create! valid_attributes
        put :update, {:id => job_spec.to_param, :job_spec => invalid_attributes}, valid_session
        expect(assigns(:job_spec)).to eq(job_spec)
      end

      it "re-renders the 'edit' template" do
        job_spec = JobSpec.create! valid_attributes
        put :update, {:id => job_spec.to_param, :job_spec => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested job_spec" do
      job_spec = JobSpec.create! valid_attributes
      expect {
        delete :destroy, {:id => job_spec.to_param}, valid_session
      }.to change(JobSpec, :count).by(-1)
    end

    it "redirects to the job_spec list" do
      job_spec = JobSpec.create! valid_attributes
      delete :destroy, {:id => job_spec.to_param}, valid_session
      expect(response).to redirect_to(job_spec_url)
    end
  end
end
