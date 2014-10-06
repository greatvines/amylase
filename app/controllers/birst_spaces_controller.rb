class BirstSpacesController < ApplicationController
  before_action :set_birst_space, only: [:show, :edit, :update, :destroy]

  # GET /birst_spaces
  # GET /birst_spaces.json
  def index
    @birst_spaces = BirstSpace.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @birst_spaces }
    end
  end

  # GET /birst_spaces/1
  # GET /birst_spaces/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @birst_space }
    end
  end

  # GET /birst_spaces/new
  def new
    @birst_space = BirstSpace.new
  end

  # GET /birst_spaces/1/edit
  def edit
  end

  # POST /birst_spaces
  # POST /birst_spaces.json
  def create
    @birst_space = BirstSpace.new(birst_space_params)

    respond_to do |format|
      if @birst_space.save
        flash[:success] = "Success! BirstSpace created."
        format.html { redirect_to @birst_space }
        format.json { render json: @birst_space, status: :created }
      else
        flash[:danger] = "Error! BirstSpace not created: #{@birst_space.errors.full_messages}"
        format.html { render action: 'new' }
        format.json { render json: @birst_space.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /birst_spaces/1
  # PATCH/PUT /birst_spaces/1.json
  def update
    respond_to do |format|
      if @birst_space.update(birst_space_params)
        flash[:success] = "Success! BirstSpace updated."
        format.html { redirect_to @birst_space }
        format.json { head :no_content }
      else
        flash[:danger] = "Error! BirstSpace not updated: #{@birst_space.errors.full_messages}"
        format.html { render action: 'edit' }
        format.json { render json: @birst_space.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /birst_spaces/1
  # DELETE /birst_spaces/1.json
  def destroy
    @birst_space.destroy
    respond_to do |format|
      flash[:success] = 'Success! BirstSpace destroyed.'
      format.html { redirect_to birst_spaces_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_birst_space
      @birst_space = BirstSpace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def birst_space_params
      params.require(:birst_space).permit(:name, :client_id, :space_type, :space_uuid)
    end
end
