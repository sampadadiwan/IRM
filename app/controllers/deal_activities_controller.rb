class DealActivitiesController < ApplicationController
  load_and_authorize_resource :except => ["search"]
  skip_before_action :verify_authenticity_token, only: [:update_sequence]

  # GET /deal_activities or /deal_activities.json
  def index
    if params[:deal_id].present?
      @deal_activities = @deal_activities.where(deal_id: params[:deal_id])
    end

    if params[:deal_investor_id].present?
      @deal_activities = @deal_activities.where(deal_investor_id: params[:deal_investor_id])
    end
    
    # Show only templates
    if params[:template].present?
      @deal_activities = @deal_activities.where(deal_investor_id: nil).order(sequence: :asc)
    else
      @deal_activities = @deal_activities.where("deal_investor_id is not null").order(sequence: :asc)
    end

    @deal_activities = @deal_activities.page params[:page]
  end

  def search
    @entity = current_user.entity
    @deal_activities = DealActivity.search(params[:query], :star => true, with: {:entity_id => current_user.entity_id})

    render "index"
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

  def update_sequence
    @deal_activity.set_list_position(params[:sequence].to_i + 1)
  end

  def toggle_completed
    @deal_activity.completed = !@deal_activity.completed 
    @deal_activity.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace( helpers.dom_id(@deal_activity.deal_investor), partial: "deals/grid_view_row", 
                                locals: {deal_investor: @deal_activity.deal_investor} )
        ]
      end
      format.html { redirect_to deal_activity_url(@deal_activity), notice: "Activity was successfully updated." }
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
      params.require(:deal_activity).permit(:deal_id, :deal_investor_id, :by_date, :status, 
                    :title, :details, :completed, :entity_id, :days)
    end
end
