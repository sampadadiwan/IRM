class AccessRightsController < ApplicationController
  before_action :set_access_right, only: %w[show update destroy edit]

  # GET /access_rights or /access_rights.json
  def index
    @access_rights = policy_scope(AccessRight).includes(:owner, :investor)

    @access_rights = @access_rights.deals.where(owner_id: params[:deal_id]) if params[:deal_id].present?

    @access_rights = @access_rights.deals.where(access_to_investor_id: params[:access_to_investor_id]) if params[:access_to_investor_id].present?
    @access_rights = @access_rights.page params[:page]
  end

  def search
    @entity = current_user.entity
    @access_rights = AccessRight.search(params[:query], star: false, with: { entity_id: current_user.entity_id })
    render "index"
  end

  # GET /access_rights/1 or /access_rights/1.json
  def show
    authorize @access_right
  end

  # GET /access_rights/new
  def new
    @access_right = AccessRight.new(access_right_params)
    authorize @access_right

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append('new_access_right', partial: "access_rights/form", locals: { access_right: @access_right, hide_owner: true })
        ]
      end
      format.html
    end
  end

  # GET /access_rights/1/edit
  def edit
    authorize @access_right
  end

  # POST /access_rights or /access_rights.json
  def create
    @access_right = AccessRight.new(access_right_params)
    @access_right.entity_id = current_user.entity_id
    authorize @access_right

    respond_to do |format|
      if @access_right.save
        format.turbo_stream { render :create }
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
    authorize @access_right
    @access_right.entity_id = current_user.entity_id

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
    authorize @access_right
    @access_right.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@access_right)
        ]
      end
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
    params.require(:access_right).permit(:owner_id, :owner_type,
                                         :access_to_investor_id, :access_type, :metadata,
                                         :entity_id, :access_to_category)
  end
end
