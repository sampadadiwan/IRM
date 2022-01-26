class DocAccessesController < ApplicationController
  include ActionView::RecordIdentifier

  load_and_authorize_resource :except => ["search"]
  
  # GET /doc_accesses or /doc_accesses.json
  def index
    @doc_accesses = @doc_accesses.includes(:document).joins(:document).page params[:page]
  end

  def search
    @entity = current_user.entity
    if current_user.is_super?
      @doc_accesses = DocAccess.search(params[:query], :star => true)
    else
      @doc_accesses = DocAccess.search(params[:query], :star => true, with: {:entity_id => current_user.entity_id})
    end

    render "index"
  end

  # GET /doc_accesses/1 or /doc_accesses/1.json
  def show
  end

  # GET /doc_accesses/new
  def new
    @doc_access = DocAccess.new(doc_access_params)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append('new_doc_access', partial: "doc_accesses/form", locals: {doc_access: @doc_access})
        ]
      end
      format.html 
    end
  end

  def send_email
    DocAccessMailer.with(doc_access: @doc_access).notify_access.deliver_later
    @doc_access.status = "Pending"
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(dom_id(@doc_access), partial: "doc_accesses/doc_access", locals: {doc_access: @doc_access})
        ]
      end
      format.html 
    end
  end

  # GET /doc_accesses/1/edit
  def edit
  end

  # POST /doc_accesses or /doc_accesses.json
  def create
    @doc_access = DocAccess.new(doc_access_params)
    @doc_access.entity_id = current_user.entity_id

    respond_to do |format|
      if @doc_access.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append('doc_accesses_table', partial: "doc_accesses/doc_access", locals: {doc_access: @doc_access})
          ]
        end
        format.html { redirect_to document_url(@doc_access.document), notice: "Document Access was successfully created." }
        format.json { render :show, status: :created, location: @doc_access }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @doc_access.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_accesses/1 or /doc_accesses/1.json
  def update
    respond_to do |format|
      if @doc_access.update(doc_access_params)
        format.html { redirect_to document_url(@doc_access.document), notice: "Document Access was successfully updated." }
        format.json { render :show, status: :ok, location: @doc_access }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @doc_access.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_accesses/1 or /doc_accesses/1.json
  def destroy
    @doc_access.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@doc_access)
        ]
      end
      format.html { redirect_to doc_accesses_url, notice: "Document Access was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_access
      @doc_access = DocAccess.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def doc_access_params
      params.require(:doc_access).permit(:document_id, :access_type, :to)
    end
end
