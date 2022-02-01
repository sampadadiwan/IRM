class InvestmentsController < ApplicationController
  load_and_authorize_resource :except => ["search"]

  # GET /investments or /investments.json
  def index
    
    if params[:entity_id].present?
      @entity = Entity.find(params[:entity_id])
      @investments = Investment.investments_for(current_user, @entity)
    else
      @entity = current_user.entity
      @investments = @investments.order(initial_value: :desc).                    
                    includes([:investor=>:investor_entity], :investee_entity)
                    
    end
    
    @investments = @investments.joins(:investor, :investee_entity).page params[:page]
  end

  def search
    @entity = current_user.entity
    # params[:query] = params[:query].delete(' ') if params[:query].present? && params[:query].include?("Series")
    if current_user.is_super?
      @investments = Investment.search(params[:query], :star => true)
    else
      @investments = Investment.search(params[:query], :star => false, with: {:investee_entity_id => current_user.entity_id})
    end

    render "index"
  end


  # GET /investments/1 or /investments/1.json
  def show
  end

  # GET /investments/new
  def new
    @investment = Investment.new
  end

  # GET /investments/1/edit
  def edit
  end

  # POST /investments or /investments.json
  def create
    @investment = Investment.new(investment_params)
    @investment.investee_entity_id = current_user.entity_id if !current_user.is_super?

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
