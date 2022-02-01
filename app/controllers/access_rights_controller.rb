class AccessRightsController < ApplicationController
  before_action :set_access_right, only: %i[ show edit update destroy ]

  # GET /access_rights or /access_rights.json
  def index
    @access_rights = AccessRight.all
  end

  # GET /access_rights/1 or /access_rights/1.json
  def show
  end

  # GET /access_rights/new
  def new
    @access_right = AccessRight.new
  end

  # GET /access_rights/1/edit
  def edit
  end

  # POST /access_rights or /access_rights.json
  def create
    @access_right = AccessRight.new(access_right_params)

    respond_to do |format|
      if @access_right.save
        format.html { redirect_to access_right_url(@access_right), notice: "Access right was successfully created." }
        format.json { render :show, status: :created, location: @access_right }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @access_right.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /access_rights/1 or /access_rights/1.json
  def update
    respond_to do |format|
      if @access_right.update(access_right_params)
        format.html { redirect_to access_right_url(@access_right), notice: "Access right was successfully updated." }
        format.json { render :show, status: :ok, location: @access_right }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @access_right.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /access_rights/1 or /access_rights/1.json
  def destroy
    @access_right.destroy

    respond_to do |format|
      format.html { redirect_to access_rights_url, notice: "Access right was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access_right
      @access_right = AccessRight.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def access_right_params
      params.require(:access_right).permit(:owner_id, :owner_type, :access_to, :access_to_investor_id, :access_type, :metadata)
    end
end
