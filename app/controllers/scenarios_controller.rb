class ScenariosController < ApplicationController
  before_action :set_scenario, only: %i[show edit update destroy]

  # GET /scenarios or /scenarios.json
  def index
    @scenarios = policy_scope(Scenario)
  end

  # GET /scenarios/1 or /scenarios/1.json
  def show; end

  # GET /scenarios/new
  def new
    @scenario = Scenario.new
    @scenario.entity_id = current_user.entity_id
    authorize @scenario
  end

  # GET /scenarios/1/edit
  def edit; end

  # POST /scenarios or /scenarios.json
  def create
    @scenario = Scenario.new(scenario_params)
    @scenario.entity_id = current_user.entity_id
    authorize @scenario

    respond_to do |format|
      if @scenario.save
        format.html { redirect_to scenario_url(@scenario), notice: "Scenario was successfully created." }
        format.json { render :show, status: :created, location: @scenario }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scenarios/1 or /scenarios/1.json
  def update
    @scenario.entity_id = current_user.entity_id
    respond_to do |format|
      if @scenario.update(scenario_params)
        format.html { redirect_to scenario_url(@scenario), notice: "Scenario was successfully updated." }
        format.json { render :show, status: :ok, location: @scenario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scenarios/1 or /scenarios/1.json
  def destroy
    @scenario.destroy
    cookies.delete(:scenario_id, domain: :all) if cookies[:scenario_id]
    respond_to do |format|
      format.html { redirect_to scenarios_url, notice: "Scenario was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_scenario
    @scenario = Scenario.find(params[:id])
    authorize @scenario
  end

  # Only allow a list of trusted parameters through.
  def scenario_params
    params.require(:scenario).permit(:name, :entity_id, :cloned_from)
  end
end
