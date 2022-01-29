class DealInvestorsController < ApplicationController
  load_and_authorize_resource :except => ["search"]

  # GET /deal_investors or /deal_investors.json
  def index
    if params[:deal_id].present?
      @deal_investors = @deal_investors.where(deal_id: params[:deal_id])
    end
  end

  # GET /deal_investors/1 or /deal_investors/1.json
  def show
  end

  # GET /deal_investors/new
  def new
    @deal_investor = DealInvestor.new(deal_id: params[:deal_id])
  end

  # GET /deal_investors/1/edit
  def edit
  end

  # POST /deal_investors or /deal_investors.json
  def create
    @deal_investor = DealInvestor.new(deal_investor_params)
    @deal_investor.entity_id = current_user.entity_id
    
    respond_to do |format|
      if @deal_investor.save
        format.html { redirect_to deal_investor_url(@deal_investor), notice: "Deal investor was successfully created." }
        format.json { render :show, status: :created, location: @deal_investor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deal_investor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deal_investors/1 or /deal_investors/1.json
  def update
    respond_to do |format|
      if @deal_investor.update(deal_investor_params)
        format.html { redirect_to deal_investor_url(@deal_investor), notice: "Deal investor was successfully updated." }
        format.json { render :show, status: :ok, location: @deal_investor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deal_investor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deal_investors/1 or /deal_investors/1.json
  def destroy
    @deal_investor.destroy

    respond_to do |format|
      format.html { redirect_to deal_investors_url, notice: "Deal investor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal_investor
      @deal_investor = DealInvestor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def deal_investor_params
      params.require(:deal_investor).permit(:deal_id, :investor_id, :status, :primary_amount, :secondary_investment, :entity_id)
    end
end
