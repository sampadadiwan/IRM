class ExcercisesController < ApplicationController
  before_action :set_excercise, only: %i[show edit update destroy]

  # GET /excercises or /excercises.json
  def index
    @excercises = policy_scope(Excercise).includes(:holding, :user, :esop_pool)
    @excercises = @excercises.where(esop_pool_id: params[:esop_pool_id]) if params[:esop_pool_id].present?
  end

  # GET /excercises/1 or /excercises/1.json
  def show; end

  # GET /excercises/new
  def new
    @excercise = Excercise.new(excercise_params)
    @excercise.entity_id = current_user.entity_id
    @excercise.user_id = current_user.id

    Rails.logger.debug @excercise.to_json

    @excercise.esop_pool_id = @excercise.holding.esop_pool_id
    @excercise.price = @excercise.esop_pool.excercise_price
    authorize(@excercise)
  end

  # GET /excercises/1/edit
  def edit; end

  # POST /excercises or /excercises.json
  def create
    @excercise = Excercise.new(excercise_params)
    @excercise.esop_pool_id = @excercise.holding.esop_pool_id
    @excercise.entity_id = current_user.entity_id
    @excercise.user_id = current_user.id

    authorize(@excercise)

    respond_to do |format|
      if @excercise.save
        format.html { redirect_to excercise_url(@excercise), notice: "Excercise was successfully created." }
        format.json { render :show, status: :created, location: @excercise }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @excercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /excercises/1 or /excercises/1.json
  def update
    @excercise.entity_id = current_user.entity_id
    @excercise.user_id = current_user.id

    respond_to do |format|
      if @excercise.update(excercise_params)
        format.html { redirect_to excercise_url(@excercise), notice: "Excercise was successfully updated." }
        format.json { render :show, status: :ok, location: @excercise }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @excercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /excercises/1 or /excercises/1.json
  def destroy
    @excercise.destroy

    respond_to do |format|
      format.html { redirect_to excercises_url, notice: "Excercise was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_excercise
    @excercise = Excercise.find(params[:id])
    authorize(@excercise)
  end

  # Only allow a list of trusted parameters through.
  def excercise_params
    params.require(:excercise).permit(:entity_id, :holding_id, :user_id, :esop_pool_id, :quantity, :price, :amount, :tax, :approved)
  end
end
