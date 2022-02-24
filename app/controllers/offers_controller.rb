class OffersController < ApplicationController
  before_action :set_offer, only: %i[show edit update destroy approve]

  # GET /offers or /offers.json
  def index
    @offers = policy_scope(Offer)
    @offers = @offers.where(secondary_sale_id: params[:secondary_sale_id]) if params[:secondary_sale_id].present?
  end

  # GET /offers/1 or /offers/1.json
  def show; end

  # GET /offers/new
  def new
    @offer = Offer.new(offer_params)
    @offer.user_id = current_user.id
    @offer.entity_id = @offer.secondary_sale.entity_id
    @offer.quantity = @offer.allowed_quantity

    authorize @offer
  end

  def approve
    @offer.approved = !@offer.approved
    @offer.granted_by_user_id = current_user.id
    @offer.save!
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(@offer, partial: "/offers/offer", locals: { show_entity: false, show_secondary_sale: false, offer: @offer })
        ]
      end
      format.html { redirect_to offer_url(@offer), notice: "Offer was successfully approved." }
      format.json { @offer.to_json }
    end
  end

  # GET /offers/1/edit
  def edit; end

  # POST /offers or /offers.json
  def create
    @offer = Offer.new(offer_params)
    authorize @offer

    respond_to do |format|
      if @offer.save
        format.html { redirect_to offer_url(@offer), notice: "Offer was successfully created." }
        format.json { render :show, status: :created, location: @offer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1 or /offers/1.json
  def update
    respond_to do |format|
      if @offer.update(offer_params)
        format.html { redirect_to offer_url(@offer), notice: "Offer was successfully updated." }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1 or /offers/1.json
  def destroy
    @offer.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@offer)
        ]
      end
      format.html { redirect_to offers_url, notice: "Offer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_offer
    @offer = Offer.find(params[:id])
    authorize @offer
  end

  # Only allow a list of trusted parameters through.
  def offer_params
    params.require(:offer).permit(:user_id, :entity_id, :secondary_sale_id,
                                  :holding_id, :quantity, :percentage, :notes)
  end
end
