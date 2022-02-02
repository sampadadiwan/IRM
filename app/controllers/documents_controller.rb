class DocumentsController < ApplicationController
  before_action :set_document, :only => ["show", "update", "destroy", "edit"] 

  # GET /documents or /documents.json
  def index
      @entity = current_user.entity
      if params[:entity_id].present?
        @entity = Entity.find(params[:entity_id])
        # @documents = Document.documents_for(current_user, @entity)
      else
        # @documents = @documents.includes(:owner)
      end
      @documents = policy_scope(Document)
      @documents = @documents.page params[:page]
  end

  def investor_documents

    if params[:entity_id].present?
     
      @entity = Entity.find(params[:entity_id])
    
      if current_user.has_role?(:all_investment_access, @entity)
        # Can view all
        @documents = @entity.documents
      elsif current_user.has_role?(:self_investment_access, @entity)
        # Can view only his documents
        @documents = @entity.documents.where("investors.investor_entity_id=?", current_user.entity_id)
      else
        # Can view none
        @documents = Investment.none
      end      
    
    end
    
    @documents = @documents.order(initial_value: :desc).joins(:investor, :investee_entity).page params[:page]

    render "index"
  end


  def search
    @entity = current_user.entity
    if current_user.has_role?(:super)
      @documents = Document.search(params[:query], :star => true)
    else
      @documents = Document.search(params[:query], :star => false, with: {:owner_id => current_user.entity_id})
    end

    render "index"
  end


  # GET /documents/1 or /documents/1.json
  def show
    
  end

  # GET /documents/new
  def new
    @document = Document.new(document_params)
    authorize @document
  end

  # GET /documents/1/edit
  def edit
    
  end

  # POST /documents or /documents.json
  def create
    @document = Document.new(document_params)
    @document.entity_id = current_user.entity_id    
    authorize @document
    
    respond_to do |format|
      if @document.save
        format.html { redirect_to document_url(@document), notice: "Document was successfully created." }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to document_url(@document), notice: "Document was successfully updated." }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1 or /documents/1.json
  def destroy
    
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url, notice: "Document was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
      authorize @document
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.require(:document).permit(:name, :file, :text, :entity_id)
    end
end
