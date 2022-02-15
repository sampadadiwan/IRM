class DocumentsController < ApplicationController
  before_action :set_document, only: %w[show update destroy edit]
  after_action :verify_authorized, except: %i[index search investor_documents]
  impressionist actions: [:show]

  # GET /documents or /documents.json
  def index
    @entity = current_user.entity
    # if params[:entity_id].present?
    #   @entity = Entity.find(params[:entity_id])
    #   # @documents = Document.documents_for(current_user, @entity)
    # else
    #   # @documents = @documents.includes(:owner)
    # end
    @documents = policy_scope(Document)
    if(params[:folder_id].present?)
      @documents = @documents.where(folder_id: params[:folder_id])
    end
    @documents = @documents.joins(:folder).includes(:folder, tags: :taggings).page params[:page]
  end

  def investor_documents
    if params[:entity_id].present?
      @entity = Entity.find(params[:entity_id])
      @documents = Document.for_investor(current_user, @entity)
    end

    @documents = @documents.order(id: :desc).page params[:page]

    render "index"
  end

  def search
    @entity = current_user.entity
    @documents = if current_user.has_role?(:super)
                   Document.search(params[:query], star: true)
                 else
                   Document.search(params[:query], star: false, with: { entity_id: current_user.entity_id })
                 end

    render "index"
  end

  # GET /documents/1 or /documents/1.json
  def show; end

  # GET /documents/new
  def new
    @document = Document.new(document_params)
    authorize @document
  end

  # GET /documents/1/edit
  def edit; end

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
    params.require(:document).permit(:name, :file, :text, :entity_id, :video, :tag_list, :folder_id)
  end
end
