class HoldingActionsController < ApplicationController
  before_action :set_holding_action, only: %i[show edit update destroy]

  # GET /holding_actions or /holding_actions.json
  def index
    @holding_actions = policy_scope(HoldingAction)
  end

  # GET /holding_actions/1 or /holding_actions/1.json
  def show; end

  # GET /holding_actions/new
  def new
    @holding_action = HoldingAction.new
    authorize(@holding_action)
  end

  # GET /holding_actions/1/edit
  def edit; end

  # POST /holding_actions or /holding_actions.json
  def create
    @holding_action = HoldingAction.new(holding_action_params)
    authorize(@holding_action)
    respond_to do |format|
      if @holding_action.save
        format.html { redirect_to holding_action_url(@holding_action), notice: "Holding action was successfully created." }
        format.json { render :show, status: :created, location: @holding_action }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @holding_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /holding_actions/1 or /holding_actions/1.json
  def update
    respond_to do |format|
      if @holding_action.update(holding_action_params)
        format.html { redirect_to holding_action_url(@holding_action), notice: "Holding action was successfully updated." }
        format.json { render :show, status: :ok, location: @holding_action }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @holding_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /holding_actions/1 or /holding_actions/1.json
  def destroy
    @holding_action.destroy

    respond_to do |format|
      format.html { redirect_to holding_actions_url, notice: "Holding action was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_holding_action
    @holding_action = HoldingAction.find(params[:id])
    authorize(@holding_action)
  end

  # Only allow a list of trusted parameters through.
  def holding_action_params
    params.require(:holding_action).permit(:entity_id, :holding_id, :user_id, :quantity, :action, :notes)
  end
end
