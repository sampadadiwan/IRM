class InvestorsController < ApplicationController
  load_and_authorize_resource :except => ["search"]

  # GET /investors or /investors.json
  def index
    @investors = @investors.order(:category)
  end

  def search
    if current_user.is_super?
      @investors = Investor.search(params[:query], :star => true)
    else
      @investors = Investor.search(params[:query], :star => true, with: {:investee_company_id => current_user.company_id})
    end

    render "index"
  end

  # GET /investors/1 or /investors/1.json
  def show
  end

  # GET /investors/new
  def new
    @investor = Investor.new
  end

  # GET /investors/1/edit
  def edit
  end

  # POST /investors or /investors.json
  def create

    if(investor_params[:company].present?)
      logger.debug "Found attached company #{investor_params[:company]}"       
    end

    @investor = Investor.new(investor_params)
    @investor.investee_company_id = current_user.company_id if !current_user.is_super?

    puts @investor.errors.full_messages

    respond_to do |format|
      if @investor.save
        format.html { redirect_to investor_url(@investor), notice: "Investor was successfully created." }
        format.json { render :show, status: :created, location: @investor }
      else
        logger.debug @investor.errors.full_messages
        
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @investor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /investors/1 or /investors/1.json
  def update
    respond_to do |format|
      if @investor.update(investor_params)
        format.html { redirect_to investor_url(@investor), notice: "Investor was successfully updated." }
        format.json { render :show, status: :ok, location: @investor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @investor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /investors/1 or /investors/1.json
  def destroy
    @investor.destroy

    respond_to do |format|
      format.html { redirect_to investors_url, notice: "Investor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_investor
      @investor = Investor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def investor_params
      params.require(:investor).permit(:investor_id, :investor_type, 
          :investee_company_id, :category, 
          :company=>[:name, :url, :category, :founded, :company_type,
          :funding_amount, :funding_unit, :details, :logo_url])
    end
end
