class InvestmentsController < ApplicationController
  before_action :set_investment, only: %w[show update destroy edit]
  after_action :verify_authorized, except: %i[index search investor_investments]

  # GET /investments or /investments.json
  def index
    @entity = current_user.entity
    @investments = policy_scope(Investment).includes(:investor, :investee_entity)
    @investments = @investments.order(initial_value: :desc)
                               .joins(:investor, :investee_entity)

    respond_to do |format|
      format.xlsx do
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename=investments.xlsx"
      end
      format.html { render :index }
      format.json { render :index }
      format.pdf do
        render template: "investments/index", formats: [:html], pdf: "#{@entity.name} Investments"
      end
    end
  end

  def investor_investments
    if params[:entity_id].present?
      @entity = Entity.find(params[:entity_id])
      @investments = Investment.for_investor(current_user, @entity)
    end

    @investments = @investments.order(initial_value: :desc)
                               .includes(:investee_entity, investor: :investor_entity).distinct
                               .page params[:page]

    render "index"
  end

  def search
    @entity = current_user.entity
    # params[:query] = params[:query].delete(' ') if params[:query].present? && params[:query].include?("Series")
    if current_user.has_role?(:super)
      @investments = Investment.search(params[:query], star: true)
    else
      # WE want to find investments that have the current_users entity as either and investor or investee
      investor_or_investee = "*, IF(investor_entity_id = #{current_user.entity_id} OR investee_entity_id = #{current_user.entity_id}, 1, 0) AS inv"
      @investments = Investment.search(params[:query], star: false,
                                                       select: investor_or_investee, with: { 'inv' => 1 }, sql: { include: %i[investor investee_entity] })
    end

    render "index"
  end

  # GET /investments/1 or /investments/1.json
  def show
    authorize @investment
    respond_to do |format|
      format.html
      format.pdf do
        render template: "investments/show", formats: [:html], pdf: "Investment #{@investment.id}"
      end
    end
  end

  # GET /investments/new
  def new
    @investment = Investment.new(investment_params)
    authorize @investment
  end

  # GET /investments/1/edit
  def edit
    authorize @investment
  end

  # POST /investments or /investments.json
  def create
    @investment = Investment.new(investment_params)
    @investment.investee_entity_id = current_user.entity_id
    @investment.currency = current_user.entity.currency
    authorize @investment

    respond_to do |format|
      if @investment.save
        InvestmentPercentageHoldingJob.perform_later(@investment.id)
        format.html { redirect_to investment_url(@investment), notice: "Investment was successfully created." }
        format.json { render :show, status: :created, location: @investment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @investment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /investments/1 or /investments/1.json
  def update
    authorize @investment
    respond_to do |format|
      if @investment.update(investment_params)
        InvestmentPercentageHoldingJob.perform_later(@investment.id)
        format.html { redirect_to investment_url(@investment), notice: "Investment was successfully updated." }
        format.json { render :show, status: :ok, location: @investment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @investment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /investments/1 or /investments/1.json
  def destroy
    authorize @investment
    @investment.destroy

    respond_to do |format|
      format.html { redirect_to investments_url, notice: "Investment was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_investment
    @investment = Investment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def investment_params
    params.require(:investment).permit(:investment_type, :funding_round_id, :investor_id, :price,
                                       :investee_entity_id, :investor_type, :investment_instrument, :quantity,
                                       :category, :initial_value, :current_value, :status)
  end
end
