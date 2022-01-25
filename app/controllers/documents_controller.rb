class DocumentsController < ApplicationController
  load_and_authorize_resource :except => ["search"]

  # GET /documents or /documents.json
  def index
      @entity = current_user.entity
      @documents = @documents.includes(:owner)
  end

  def search
    if current_user.is_super?
      @documents = Document.search(params[:query], :star => true)
    else
      @documents = Document.search(params[:query], :star => true, with: {:owner_id => current_user.entity_id})
    end

    render "index"
  end


  # GET /documents/1 or /documents/1.json
  def show
  end

  # GET /documents/new
  def new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents or /documents.json
  def create
    @document = Document.new(document_params)
    @document.owner_id = current_user.entity_id
    @document.owner_type = "Entity"

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
      format.html { redirect_to documents_url, notice: "Document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.require(:document).permit(:name,:owner_id, :owner_type, :file, :text)
    end
end
