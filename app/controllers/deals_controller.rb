class DealsController < ApplicationController
  before_action :set_deal, only: %w[show update destroy edit start_deal]
  after_action :verify_authorized, except: %i[index search investor_deals]

  # GET /deals or /deals.json
  def index
    @deals = policy_scope(Deal)

    @deals = if params[:other_deals].present?
               Deal.deals_for_vc(current_user)
             else
               @deals.includes(:entity)
             end

    @deals = @deals.page params[:page]
  end

  def search
    @entity = current_user.entity
    @deals = Deal.search(params[:query], star: false, with: { entity_id: current_user.entity_id })

    render "index"
  end

  def investor_deals
    @deals = Deal.for_investor(current_user)
    @deals = @deals.page params[:page]
    render "index"
  end

  # GET /deals/1 or /deals/1.json
  def show
    authorize @deal
    if params[:grid_view].present?
      render "grid_view"
    else
      render "show"
    end
  end

  # GET /deals/new
  def new
    @deal = Deal.new(deal_params)
    @deal.activity_list = Deal::ACTIVITIES
    authorize @deal
  end

  # GET /deals/1/edit
  def edit
    authorize @deal
  end

  def start_deal
    authorize @deal
    Deal.public_activity_off
    @deal.start_deal
    Deal.public_activity_on
    @deal.create_activity key: 'deal.started', owner: current_user

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('deal_show', partial: "deals/show", locals: { deal: @deal })
        ]
      end
      format.html { redirect_to deal_url(@deal), notice: "Deal was successfully started." }
    end
  end

  # POST /deals or /deals.json
  def create
    @deal = Deal.new(deal_params)
    @deal.entity_id = current_user.entity_id
    authorize @deal

    respond_to do |format|
      if @deal.save
        format.html { redirect_to deal_url(@deal), notice: "Deal was successfully created." }
        format.json { render :show, status: :created, location: @deal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deals/1 or /deals/1.json
  def update
    authorize @deal

    respond_to do |format|
      if @deal.update(deal_params)
        format.html { redirect_to deal_url(@deal), notice: "Deal was successfully updated." }
        format.json { render :show, status: :ok, location: @deal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deals/1 or /deals/1.json
  def destroy
    authorize @deal
    @deal.destroy

    respond_to do |format|
      format.html { redirect_to deals_url, notice: "Deal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_deal
    @deal = Deal.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def deal_params
    params.require(:deal).permit(:entity_id, :name, :amount, :status, :activity_list)
  end
end
