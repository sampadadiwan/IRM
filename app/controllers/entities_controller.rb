class EntitiesController < ApplicationController
  load_and_authorize_resource :except => ["search"]


  # GET /entities or /entities.json
  def index
  end

  def dashboard
  end

  def investor_view
      @investments = Investment.investments_for(current_user, @entity)
      @documents = Document.documents_for(current_user, @entity)
  end

  def search
    if current_user.is_super?
      @entities = Entity.search(params[:query], :star => true)
    else
      @entities = Entity.search(params[:query], :star => true)
    end

    render "index"
  end


  # GET /entities/1 or /entities/1.json
  def show; end

  # GET /entities/new
  def new
    @entity = params[:entity].present? ? Entity.new(entity_params) : Entity.new
  end

  # GET /entities/1/edit
  def edit; end

  # POST /entities or /entities.json
  def create
    @entity =  Entity.new(entity_params)  
    @entity.created_by = current_user.id

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
      format.html { redirect_to entities_url, notice: "Entity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_entity
    @entity = Entity.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def entity_params
    params.require(:entity).permit(:name, :url, :category, :founded, :entity_type,
                                    :funding_amount, :funding_unit, :details, :logo_url)
  end
end
