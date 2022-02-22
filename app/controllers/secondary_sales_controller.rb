class SecondarySalesController < ApplicationController
  before_action :set_secondary_sale, only: %i[show edit update destroy]
  after_action :verify_policy_scoped, only: []

  # GET /secondary_sales or /secondary_sales.json
  def index
    @secondary_sales = if current_user.has_cached_role?(:holding)
                         SecondarySale.none
                       else
                         policy_scope(SecondarySale)
                       end
  end

  # GET /secondary_sales/1 or /secondary_sales/1.json
  def show; end

  # GET /secondary_sales/new
  def new
    @secondary_sale = SecondarySale.new(secondary_sale_params)
    @secondary_sale.entity_id = current_user.entity_id
    @secondary_sale.start_date = Time.zone.today
    @secondary_sale.end_date = Time.zone.today + 2.weeks
    @secondary_sale.percent_allowed = 100
    authorize @secondary_sale
  end

  # GET /secondary_sales/1/edit
  def edit; end

  # POST /secondary_sales or /secondary_sales.json
  def create
    @secondary_sale = SecondarySale.new(secondary_sale_params)
    @secondary_sale.entity_id = current_user.entity_id
    authorize @secondary_sale

    respond_to do |format|
      if @secondary_sale.save
        format.html { redirect_to secondary_sale_url(@secondary_sale), notice: "Secondary sale was successfully created." }
        format.json { render :show, status: :created, location: @secondary_sale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @secondary_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /secondary_sales/1 or /secondary_sales/1.json
  def update
    respond_to do |format|
      if @secondary_sale.update(secondary_sale_params)
        format.html { redirect_to secondary_sale_url(@secondary_sale), notice: "Secondary sale was successfully updated." }
        format.json { render :show, status: :ok, location: @secondary_sale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @secondary_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secondary_sales/1 or /secondary_sales/1.json
  def destroy
    @secondary_sale.destroy

    respond_to do |format|
      format.html { redirect_to secondary_sales_url, notice: "Secondary sale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_secondary_sale
    @secondary_sale = SecondarySale.find(params[:id])
    authorize @secondary_sale
  end

  # Only allow a list of trusted parameters through.
  def secondary_sale_params
    params.require(:secondary_sale).permit(:name, :entity_id, :start_date, :end_date, :percent_allowed, :min_price, :max_price, :active)
  end
end
