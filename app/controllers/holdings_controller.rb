class HoldingsController < ApplicationController
  before_action :set_holding, only: %i[show edit update destroy]
  after_action :verify_authorized, except: %i[employee_calc]

  # GET /holdings or /holdings.json
  def index
    @holdings = policy_scope(Holding).order(quantity: :desc)
    @holdings = @holdings.includes(:user, :entity, :investor, :funding_round)
    @secondary_sale = nil
    if params[:secondary_sale_id]
      @secondary_sale = SecondarySale.find(params[:secondary_sale_id])
      @holdings = @holdings.where(entity_id: @secondary_sale.entity_id)
    end
    @holdings = @holdings.where(entity_id: params[:entity_id]) if params[:entity_id].present?
    @holdings = @holdings.where(funding_round_id: params[:funding_round_id]) if params[:funding_round_id].present?
    @holdings = @holdings.where(holding_type: params[:holding_type]) if params[:holding_type].present?
    @holdings = @holdings.where(investment_instrument: params[:investment_instrument]) if params[:investment_instrument].present?
    @holdings = @holdings.limit params[:limit] if params[:limit]
  end

  def search
    @entity = current_user.entity
    query = params[:query]
    if query.present?
      @holdings = if current_user.has_role?(:super)

                    HoldingIndex.query(query_string: { fields: HoldingIndex::SEARCH_FIELDS,
                                                       query:, default_operator: 'and' }).objects

                  else
                    HoldingIndex.filter(term: { entity_id: @entity.id })
                                .query(query_string: { fields: HoldingIndex::SEARCH_FIELDS,
                                                       query:, default_operator: 'and' }).objects
                  end

    end
    render "index"
  end

  # GET /holdings/1 or /holdings/1.json
  def show; end

  # GET /holdings/new
  def new
    @holding = Holding.new(holding_params)
    @holding.entity_id = current_user.entity_id
    @holding.holding_type = @holding.investor.category
    authorize @holding
  end

  # GET /holdings/1/edit
  def edit; end

  # POST /holdings or /holdings.json
  def create
    @holding = Holding.new(holding_params)
    authorize @holding

    respond_to do |format|
      if @holding.save
        format.html { redirect_to holding_url(@holding), notice: "Holding was successfully created." }
        format.json { render :show, status: :created, location: @holding }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @holding.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /holdings/1 or /holdings/1.json
  def update
    respond_to do |format|
      if @holding.update(holding_params)
        format.html { redirect_to holding_url(@holding), notice: "Holding was successfully updated." }
        format.json { render :show, status: :ok, location: @holding }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @holding.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /holdings/1 or /holdings/1.json
  def destroy
    @holding.destroy

    respond_to do |format|
      format.html { redirect_to holdings_url, notice: "Holding was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def employee_calc; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_holding
    @holding = Holding.find(params[:id])
    authorize @holding
  end

  # Only allow a list of trusted parameters through.
  def holding_params
    params.require(:holding).permit(:user_id, :investor_id, :entity_id, :quantity, :price,
                                    :value, :investment_instrument, :holding_type, :funding_round_id, :esop_pool_id, :grant_date, :employee_id)
  end
end
