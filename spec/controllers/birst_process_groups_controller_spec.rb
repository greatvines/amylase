require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe BirstProcessGroupsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # BirstProcessGroup. As you add validations to BirstProcessGroup, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryGirl.build(:birst_process_group).attributes
  }

  let(:invalid_attributes) {
    FactoryGirl.create(:birst_process_group).attributes
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BirstProcessGroupsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all birst_process_groups as @birst_process_groups" do
      birst_process_group = BirstProcessGroup.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:birst_process_groups)).to eq([birst_process_group])
    end
  end

  describe "GET show" do
    it "assigns the requested birst_process_group as @birst_process_group" do
      birst_process_group = BirstProcessGroup.create! valid_attributes
      get :show, {:id => birst_process_group.to_param}, valid_session
      expect(assigns(:birst_process_group)).to eq(birst_process_group)
    end
  end

  describe "GET new" do
    it "assigns a new birst_process_group as @birst_process_group" do
      get :new, {}, valid_session
      expect(assigns(:birst_process_group)).to be_a_new(BirstProcessGroup)
    end
  end

  describe "GET edit" do
    it "assigns the requested birst_process_group as @birst_process_group" do
      birst_process_group = BirstProcessGroup.create! valid_attributes
      get :edit, {:id => birst_process_group.to_param}, valid_session
      expect(assigns(:birst_process_group)).to eq(birst_process_group)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BirstProcessGroup" do
        expect {
          post :create, {:birst_process_group => valid_attributes}, valid_session
        }.to change(BirstProcessGroup, :count).by(1)
      end

      it "assigns a newly created birst_process_group as @birst_process_group" do
        post :create, {:birst_process_group => valid_attributes}, valid_session
        expect(assigns(:birst_process_group)).to be_a(BirstProcessGroup)
        expect(assigns(:birst_process_group)).to be_persisted
      end

      it "redirects to the created birst_process_group" do
        post :create, {:birst_process_group => valid_attributes}, valid_session
        expect(response).to redirect_to(BirstProcessGroup.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved birst_process_group as @birst_process_group" do
        post :create, {:birst_process_group => invalid_attributes}, valid_session
        expect(assigns(:birst_process_group)).to be_a_new(BirstProcessGroup)
      end

      it "re-renders the 'new' template" do
        post :create, {:birst_process_group => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        valid_attributes.merge({ 'description' => 'some new description' })
      }

      it "updates the requested birst_process_group" do
        birst_process_group = BirstProcessGroup.create! valid_attributes
        put :update, {:id => birst_process_group.to_param, :birst_process_group => new_attributes}, valid_session
        birst_process_group.reload
        expect(birst_process_group.description).to eq 'some new description'
      end

      it "assigns the requested birst_process_group as @birst_process_group" do
        birst_process_group = BirstProcessGroup.create! valid_attributes
        put :update, {:id => birst_process_group.to_param, :birst_process_group => valid_attributes}, valid_session
        expect(assigns(:birst_process_group)).to eq(birst_process_group)
      end

      it "redirects to the birst_process_group" do
        birst_process_group = BirstProcessGroup.create! valid_attributes
        put :update, {:id => birst_process_group.to_param, :birst_process_group => valid_attributes}, valid_session
        expect(response).to redirect_to(birst_process_group)
      end
    end

    describe "with invalid params" do
      it "assigns the birst_process_group as @birst_process_group" do
        birst_process_group = BirstProcessGroup.create! valid_attributes
        put :update, {:id => birst_process_group.to_param, :birst_process_group => invalid_attributes}, valid_session
        expect(assigns(:birst_process_group)).to eq(birst_process_group)
      end

      it "re-renders the 'edit' template" do
        birst_process_group = BirstProcessGroup.create! valid_attributes
        put :update, {:id => birst_process_group.to_param, :birst_process_group => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested birst_process_group" do
      birst_process_group = BirstProcessGroup.create! valid_attributes
      expect {
        delete :destroy, {:id => birst_process_group.to_param}, valid_session
      }.to change(BirstProcessGroup, :count).by(-1)
    end

    it "redirects to the birst_process_groups list" do
      birst_process_group = BirstProcessGroup.create! valid_attributes
      delete :destroy, {:id => birst_process_group.to_param}, valid_session
      expect(response).to redirect_to(birst_process_groups_url)
    end
  end

end