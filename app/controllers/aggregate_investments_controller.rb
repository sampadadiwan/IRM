class AggregateInvestmentsController < ApplicationController
  before_action :set_aggregate_investment, only: %i[show edit update destroy]

  # GET /aggregate_investments or /aggregate_investments.json
  def index
    @aggregate_investments = policy_scope(AggregateInvestment)
    @aggregate_investments.includes(:investor, :investee_entity, :scenario, :funding_round)
  end

  # GET /aggregate_investments/1 or /aggregate_investments/1.json
  def show; end

  # GET /aggregate_investments/new
  def new
    @aggregate_investment = AggregateInvestment.new
    authorize @aggregate_investment
  end

  # GET /aggregate_investments/1/edit
  def edit; end

  # POST /aggregate_investments or /aggregate_investments.json
  def create
    @aggregate_investment = AggregateInvestment.new(aggregate_investment_params)
    authorize @aggregate_investment
    respond_to do |format|
      if @aggregate_investment.save
        format.html { redirect_to aggregate_investment_url(@aggregate_investment), notice: "Aggregate investment was successfully created." }
        format.json { render :show, status: :created, location: @aggregate_investment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @aggregate_investment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aggregate_investments/1 or /aggregate_investments/1.json
  def update
    respond_to do |format|
      if @aggregate_investment.update(aggregate_investment_params)
        format.html { redirect_to aggregate_investment_url(@aggregate_investment), notice: "Aggregate investment was successfully updated." }
        format.json { render :show, status: :ok, location: @aggregate_investment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @aggregate_investment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aggregate_investments/1 or /aggregate_investments/1.json
  def destroy
    @aggregate_investment.destroy

    respond_to do |format|
      format.html { redirect_to aggregate_investments_url, notice: "Aggregate investment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_aggregate_investment
    @aggregate_investment = AggregateInvestment.find(params[:id])
    authorize @aggregate_investment
  end

  # Only allow a list of trusted parameters through.
  def aggregate_investment_params
    params.require(:aggregate_investment).permit(:entity_id, :funding_round_id, :shareholder,
                                                 :investor_id, :equity, :preferred, :option, :percentage, :full_diluted_percentage)
  end
end
