class EsopPoolsController < ApplicationController
  before_action :set_esop_pool, only: %i[show edit update destroy]

  # GET /esop_pools or /esop_pools.json
  def index
    @esop_pools = policy_scope(EsopPool).includes(:entity, :funding_round)
  end

  # GET /esop_pools/1 or /esop_pools/1.json
  def show; end

  # GET /esop_pools/new
  def new
    @esop_pool = EsopPool.new
    @esop_pool.entity_id = current_user.entity_id
    authorize(@esop_pool)
  end

  # GET /esop_pools/1/edit
  def edit; end

  # POST /esop_pools or /esop_pools.json
  def create
    @esop_pool = EsopPool.new(esop_pool_params)
    @esop_pool.entity_id = current_user.entity_id
    authorize(@esop_pool)

    respond_to do |format|
      if @esop_pool.save
        format.html { redirect_to esop_pool_url(@esop_pool), notice: "Esop pool was successfully created." }
        format.json { render :show, status: :created, location: @esop_pool }
      else
        Rails.logger.debug @esop_pool.to_json(include: :vesting_schedules)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @esop_pool.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /esop_pools/1 or /esop_pools/1.json
  def update
    respond_to do |format|
      if @esop_pool.update(esop_pool_params)
        format.html { redirect_to esop_pool_url(@esop_pool), notice: "Esop pool was successfully updated." }
        format.json { render :show, status: :ok, location: @esop_pool }
      else
        Rails.logger.debug @esop_pool.to_json(include: :vesting_schedules)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @esop_pool.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /esop_pools/1 or /esop_pools/1.json
  def destroy
    @esop_pool.destroy

    respond_to do |format|
      format.html { redirect_to esop_pools_url, notice: "Esop pool was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_esop_pool
    @esop_pool = EsopPool.find(params[:id])
    authorize(@esop_pool)
  end

  # Only allow a list of trusted parameters through.
  def esop_pool_params
    params.require(:esop_pool).permit(:name, :start_date, :number_of_options, :excercise_price, :excercise_period_months, :entity_id, :funding_round_id,
                                      vesting_schedules_attributes: %i[id months_from_grant vesting_percent _destroy])
  end
end
