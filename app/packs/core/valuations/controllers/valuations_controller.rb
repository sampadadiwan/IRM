class ValuationsController < ApplicationController
  before_action :set_valuation, only: %i[show edit update destroy]
  skip_after_action :verify_policy_scoped, only: :index

  # GET /valuations or /valuations.json
  def index
    if params[:owner_id].present? && params[:owner_type].present?
      # Ensure user is authorized to see the owner
      owner = Object.const_get(params[:owner_type]).send(:find, params[:owner_id])
      authorize(owner, :show?)
      @valuations = owner.valuations
    else
      @valuations = policy_scope(Valuation)
    end

    @valuations = @valuations.where(import_upload_id: params[:import_upload_id]) if params[:import_upload_id].present?
    @valuations = @valuations.includes(:entity)
  end

  # GET /valuations/1 or /valuations/1.json
  def show; end

  # GET /valuations/new
  def new
    @valuation = Valuation.new(valuation_params)
    @valuation.entity_id = @valuation.owner&.entity_id || current_user.entity_id
    @valuation.valuation_date = Time.zone.today
    authorize @valuation
    setup_custom_fields(@valuation)
  end

  # GET /valuations/1/edit
  def edit
    setup_custom_fields(@valuation)
  end

  # POST /valuations or /valuations.json
  def create
    valuations = []
    saved_all = true
    # We need to create a valuation for each investment instrument
    Valuation.transaction do
      params[:investment_instrument_ids].each do |investment_instrument_id|
        @valuation = Valuation.new(valuation_params)
        @valuation.investment_instrument_id = investment_instrument_id
        @valuation.entity_id = @valuation.owner&.entity_id || current_user.entity_id
        @valuation.per_share_value_cents = valuation_params[:per_share_value].to_f * 100
        @valuation.valuation_cents = valuation_params[:valuation].to_f * 100
        authorize @valuation
        saved_all &&= @valuation.save
        valuations << @valuation
      end
    end

    respond_to do |format|
      if saved_all
        notice = "Valuation was successfully created."
        if @valuation.owner_type == "Entity"
          format.html { redirect_to valuation_url(@valuation), notice: }
        else
          format.html { redirect_to [@valuation.owner, { tab: "valuations-tab" }], notice: }
        end
        format.json { render :show, status: :created, location: @valuation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @valuation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /valuations/1 or /valuations/1.json
  def update
    @valuation.per_share_value_cents = valuation_params[:per_share_value].to_f * 100
    @valuation.valuation_cents = valuation_params[:valuation].to_f * 100

    respond_to do |format|
      if @valuation.update(valuation_params)
        format.html { redirect_to valuation_url(@valuation), notice: "Valuation was successfully updated." }
        format.json { render :show, status: :ok, location: @valuation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @valuation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /valuations/1 or /valuations/1.json
  def destroy
    @valuation.destroy

    respond_to do |format|
      format.html do
        redirect_to @valuation.owner || valuations_url, notice: "Valuation was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_valuation
    @valuation = Valuation.find(params[:id])
    authorize @valuation
    @bread_crumbs = { Stakeholders: investors_path(entity_id: @valuation.entity_id), "#{@valuation.owner&.investor_name}": investor_path(@valuation.owner), Valuation: valuation_path(@valuation) }
  end

  # Only allow a list of trusted parameters through.
  def valuation_params
    params.require(:valuation).permit(:entity_id, :valuation_date, :investment_instrument_id, :owner_id, :owner_type, :form_type_id, :per_share_value, :report, :valuation, properties: {})
  end
end
