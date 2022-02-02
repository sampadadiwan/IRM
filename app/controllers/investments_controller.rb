class InvestmentsController < ApplicationController
  before_action :set_investment, :only => ["show", "update", "destroy", "edit"] 
  after_action :verify_authorized, except: [:index, :search, :investor_investments]

  # GET /investments or /investments.json
  def index    
    @entity = current_user.entity
    @investments = policy_scope(Investment)                        
    @investments = @investments.order(initial_value: :desc).
                                joins(:investor, :investee_entity).
                                page params[:page]

  end

  def investor_investments

    if params[:entity_id].present?
     
      @entity = Entity.find(params[:entity_id])
    
      if current_user.has_role?(:all_investment_access, @entity)
        # Can view all
        @investments = @entity.investments
      elsif current_user.has_role?(:self_investment_access, @entity)
        # Can view only his investments
        @investments = @entity.investments.where("investors.investor_entity_id=?", current_user.entity_id)
      else
        # Can view none
        @investments = Investment.none
      end      
    
    end
    
    @investments = @investments.order(initial_value: :desc).joins(:investor, :investee_entity).page params[:page]

    render "index"
  end

  def search
    @entity = current_user.entity
    # params[:query] = params[:query].delete(' ') if params[:query].present? && params[:query].include?("Series")
    if current_user.has_role?(:super)
      @investments = Investment.search(params[:query], :star => true)
    else
      @investments = Investment.search(params[:query], :star => false, with: {:investee_entity_id => current_user.entity_id})
    end

    render "index"
  end


  # GET /investments/1 or /investments/1.json
  def show
    authorize @investment
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
    authorize @investment

    respond_to do |format|
      if @investment.save
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
      params.require(:investment).permit(:investment_type, :investor_id, 
        :investee_entity_id, :investor_type, :investment_instrument, :quantity, 
        :category, :initial_value, :current_value, :status)
    end
end
