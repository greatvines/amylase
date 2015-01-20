class ExternalCredentialsController < ApplicationController
  before_action :set_external_credential, only: [:show, :edit, :update, :destroy]

  # GET /external_credentials
  # GET /external_credentials.json
  def index
    @external_credentials = ExternalCredential.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @external_credentials }
    end
  end

  # GET /external_credentials/1
  # GET /external_credentials/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @external_credential }
    end
  end

  # GET /external_credentials/new
  def new
    @external_credential = ExternalCredential.new
  end

  # GET /external_credentials/1/edit
  def edit
  end

  # POST /external_credentials
  # POST /external_credentials.json
  def create
    @external_credential = ExternalCredential.new(external_credential_params)

    respond_to do |format|
      if @external_credential.save
        flash[:success] = "Success! ExternalCredential created."
        format.html { redirect_to @external_credential }
        format.json { render json: @external_credential, status: :created }
      else
        flash[:danger] = "Error! ExternalCredential not created: #{@external_credential.errors.full_messages}"
        format.html { render action: 'new' }
        format.json { render json: @external_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /external_credentials/1
  # PATCH/PUT /external_credentials/1.json
  def update
    respond_to do |format|
      if @external_credential.update(external_credential_params)
        flash[:success] = "Success! ExternalCredential updated."
        format.html { redirect_to @external_credential }
        format.json { head :no_content }
      else
        flash[:danger] = "Error! ExternalCredential not updated: #{@external_credential.errors.full_messages}"
        format.html { render action: 'edit' }
        format.json { render json: @external_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_credentials/1
  # DELETE /external_credentials/1.json
  def destroy
    @external_credential.destroy
    respond_to do |format|
      flash[:success] = 'Success! ExternalCredential destroyed.'
      format.html { redirect_to external_credentials_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_credential
      @external_credential = ExternalCredential.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def external_credential_params
      params.require(:external_credential).permit(:name, :description, :username, :password)
    end
end
