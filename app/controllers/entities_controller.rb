class EntitiesController < ApplicationController
  before_action :set_entity, only: %w[show update destroy edit]
  after_action :verify_authorized, except: %i[dashboard search index investor_entities]

  # GET /entities or /entities.json
  def index
    @entities = policy_scope(Entity)
    render "index", locals: { vc_view: false }
  end

  def dashboard
    @entities = Entity.all
  end

  def investor_entities
    @entities = Entity.for_investor(current_user)
    render "index", locals: { vc_view: true }
  end

  def search
    @entities = Entity.search(params[:query], star: true)

    render "index", locals: { vc_view: true }
  end

  # GET /entities/1 or /entities/1.json
  def show; end

  # GET /entities/new
  def new; end

  # GET /entities/1/edit
  def edit; end

  # POST /entities or /entities.json
  def create
    @entity = Entity.new(entity_params)
    @entity.created_by = current_user.id
    authorize @entity

    respond_to do |format|
      if @entity.save
        format.html { redirect_to entity_url(@entity), notice: "Entity was successfully created." }
        format.json { render :show, status: :created, location: @entity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entities/1 or /entities/1.json
  def update
    respond_to do |format|
      if @entity.update(entity_params)
        format.html { redirect_to entity_url(@entity), notice: "Entity was successfully updated." }
        format.json { render :show, status: :ok, location: @entity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entities/1 or /entities/1.json
  def destroy
    @entity.destroy

    respond_to do |format|
      format.html { redirect_to entities_url, notice: "Entity was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_entity
    @entity = Entity.find(params[:id])
    authorize @entity
  end

  # Only allow a list of trusted parameters through.
  def entity_params
    params.require(:entity).permit(:name, :url, :category, :founded, :entity_type,
                                   :funding_amount, :funding_unit, :details, :logo_url,
                                   :investor_categories, :instrument_types,
                                   :currency, :units)
  end
end
