class FundFormulasController < ApplicationController
  before_action :set_fund_formula, only: %i[show edit update destroy]

  # GET /fund_formulas or /fund_formulas.json
  def index
    @fund_formulas = policy_scope(FundFormula)
    @fund_formulas = @fund_formulas.where(fund_id: params[:fund_id]) if params[:fund_id].present?
    @fund_formulas = @fund_formulas.order(:fund_id, sequence: :asc)
  end

  # GET /fund_formulas/1 or /fund_formulas/1.json
  def show; end

  # GET /fund_formulas/new
  def new
    @fund_formula = FundFormula.new(fund_formula_params)
    authorize @fund_formula
  end

  # GET /fund_formulas/1/edit
  def edit; end

  # POST /fund_formulas or /fund_formulas.json
  def create
    @fund_formula = FundFormula.new(fund_formula_params)
    authorize @fund_formula

    respond_to do |format|
      if @fund_formula.save
        format.html { redirect_to fund_formula_url(@fund_formula), notice: "Fund formula was successfully created." }
        format.json { render :show, status: :created, location: @fund_formula }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fund_formula.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fund_formulas/1 or /fund_formulas/1.json
  def update
    respond_to do |format|
      if @fund_formula.update(fund_formula_params)
        format.html { redirect_to fund_formula_url(@fund_formula), notice: "Fund formula was successfully updated." }
        format.json { render :show, status: :ok, location: @fund_formula }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fund_formula.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fund_formulas/1 or /fund_formulas/1.json
  def destroy
    @fund_formula.destroy

    respond_to do |format|
      format.html { redirect_to fund_formulas_url(fund_id: @fund_formula.fund_id), notice: "Fund formula was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fund_formula
    @fund_formula = FundFormula.find(params[:id])
    authorize @fund_formula
    @bread_crumbs = { Funds: funds_path, "#{@fund_formula.fund.name}": fund_path(@fund_formula.fund),
                      'Fund Formulas': fund_formulas_path(fund_id: @fund_formula.fund_id),
                      "#{@fund_formula}": nil }
  end

  # Only allow a list of trusted parameters through.
  def fund_formula_params
    params.require(:fund_formula).permit(:fund_id, :name, :description, :formula, :sequence, :rule_type, :entity_id, :enabled, :entry_type)
  end
end
