class DocumentsController < ApplicationController
  load_and_authorize_resource

  # GET /documents or /documents.json
  def index
      if params[:company_id].present? && current_user.company_id != params[:company_id].to_i
        c = Company.find(params[:company_id])
        if c.present? 
          investor = c.investors.where(investor_company_id: current_user.company_id).first
          if investor.present?
            @documents = Document.where(owner_type: "Company", owner_id:params[:company_id])            
            @documents = @documents.select{|doc| doc.visible_to.include?(c.categoty)}
          end
        end
      end
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
    @document.owner_id = current_user.company_id
    @document.owner_type = "Company"

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
      params.require(:document).permit(:name,:owner_id, :owner_type, :file, :visible_to=>[])
    end
end
