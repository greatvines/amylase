class TplDevTestsController < ApplicationController
  before_action :set_tpl_dev_test, only: [:show, :edit, :update, :destroy]

  # GET /tpl_dev_tests
  # GET /tpl_dev_tests.json
  def index
    @tpl_dev_tests = TplDevTest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tpl_dev_tests }
    end
  end

  # GET /tpl_dev_tests/1
  # GET /tpl_dev_tests/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tpl_dev_test }
    end
  end

  # GET /tpl_dev_tests/new
  def new
    @tpl_dev_test = TplDevTest.new
  end

  # GET /tpl_dev_tests/1/edit
  def edit
  end

  # POST /tpl_dev_tests
  # POST /tpl_dev_tests.json
  def create
    @tpl_dev_test = TplDevTest.new(tpl_dev_test_params)

    respond_to do |format|
      if @tpl_dev_test.save
        format.html { redirect_to @tpl_dev_test, notice: 'Tpl dev test was successfully created.' }
        format.json { render json: @tpl_dev_test, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @tpl_dev_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tpl_dev_tests/1
  # PATCH/PUT /tpl_dev_tests/1.json
  def update
    respond_to do |format|
      if @tpl_dev_test.update(tpl_dev_test_params)
        format.html { redirect_to @tpl_dev_test, notice: 'Tpl dev test was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tpl_dev_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tpl_dev_tests/1
  # DELETE /tpl_dev_tests/1.json
  def destroy
    @tpl_dev_test.destroy
    respond_to do |format|
      format.html { redirect_to tpl_dev_tests_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tpl_dev_test
      @tpl_dev_test = TplDevTest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tpl_dev_test_params
      params.require(:tpl_dev_test).permit(:argument)
    end
end
