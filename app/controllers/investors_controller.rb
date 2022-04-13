class InvestorsController < ApplicationController
  before_action :set_investor, only: %w[show update destroy edit]
  # after_action :verify_authorized, except: [:search]

  # GET /investors or /investors.json
  def index
    @investors = policy_scope(Investor)
    @investors = @investors.where(category: params[:category]) if params[:category]

    @investors = @investors.order("investors.id desc")
                           .includes(tags: :taggings)
  end

  def search
    @investors = if current_user.has_role?(:super)
                   Investor.search(params[:query], star: true)
                 else
                   Investor.search(params[:query], star: false, with: { investee_entity_id: current_user.entity_id })
                 end

    render "index"
  end

  # GET /investors/1 or /investors/1.json
  def show
    authorize @investor
  end

  # GET /investors/new
  def new
    @investor = Investor.new(investor_params)
    authorize @investor
  end

  # GET /investors/1/edit
  def edit
    authorize @investor
  end

  # POST /investors or /investors.json
  def create
    @investor = Investor.new(investor_params)
    @investor.investee_entity_id = current_user.entity_id unless current_user.has_role?(:super)
    authorize @investor

    respond_to do |format|
      if @investor.save
        redirect_url = params[:back_to].presence || investor_url(@investor)
        format.html { redirect_to redirect_url, notice: "Investor was successfully created." }
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
    authorize @investor
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
    authorize @investor
    @investor.destroy

    respond_to do |format|
      format.html { redirect_to investors_url, notice: "Investor was successfully deleted." }
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
    params.require(:investor).permit(:investor_entity_id, :tag_list, :investor_name,
                                     :investee_entity_id, :category)
  end
end
