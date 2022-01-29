class DealActivitiesController < ApplicationController
  load_and_authorize_resource :except => ["search"]

  # GET /deal_activities or /deal_activities.json
  def index
    if params[:deal_id].present?
      @deal_activities = @deal_activities.where(deal_id: params[:deal_id])
    end

    if params[:deal_investor_id].present?
      @deal_activities = @deal_activities.where(deal_investor_id: params[:deal_investor_id])
    end
  end

  # GET /deal_activities/1 or /deal_activities/1.json
  def show
  end

  # GET /deal_activities/new
  def new
    @deal_activity = DealActivity.new(deal_id: params[:deal_id], deal_investor_id: params[:deal_investor_id])
  end

  # GET /deal_activities/1/edit
  def edit
  end

  # POST /deal_activities or /deal_activities.json
  def create
    @deal_activity = DealActivity.new(deal_activity_params)
    @deal_activity.entity_id = current_user.entity_id
    
    respond_to do |format|
      if @deal_activity.save
        format.html { redirect_to deal_activity_url(@deal_activity), notice: "Deal activity was successfully created." }
        format.json { render :show, status: :created, location: @deal_activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deal_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deal_activities/1 or /deal_activities/1.json
  def update
    respond_to do |format|
      if @deal_activity.update(deal_activity_params)
        format.html { redirect_to deal_activity_url(@deal_activity), notice: "Deal activity was successfully updated." }
        format.json { render :show, status: :ok, location: @deal_activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deal_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deal_activities/1 or /deal_activities/1.json
  def destroy
    @deal_activity.destroy

    respond_to do |format|
      format.html { redirect_to deal_activities_url, notice: "Deal activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal_activity
      @deal_activity = DealActivity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def deal_activity_params
      params.require(:deal_activity).permit(:deal_id, :deal_investor_id, :by_date, :status, :completed, :entity_id)
    end
end
