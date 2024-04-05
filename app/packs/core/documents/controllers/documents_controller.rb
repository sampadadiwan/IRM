class DocumentsController < ApplicationController
  include ActiveStorage::SetCurrent
  include DocumentHelper

  skip_before_action :verify_authenticity_token, :set_current_entity, :authenticate_user!, :set_search_controller, only: %i[signature_progress]

  before_action :set_document, only: %w[show update destroy edit send_for_esign fetch_esign_updates force_send_for_esign cancel_esign]

  after_action :verify_authorized, except: %i[index search investor folder signature_progress approve bulk_actions]

  after_action :verify_policy_scoped, only: []

  impressionist actions: [:show]

  def signature_progress
    # Check response  - if contains proper info then update doc esign status
    # if not then just respond with 200 OK
    DigioEsignHelper.new.update_signature_progress(params)
    # Always respond with 200 OK - Expected from Digio
    render json: "Ok"
  end

  def fetch_esign_updates
    DocumentEsignUpdateJob.new.perform(@document.id, current_user.id)
    redirect_to [@document, { tab: "signatures-tab" }], notice: "Fetching Updates for E-Signatures"
  end

  # GET /documents or /documents.json
  def index
    fetch_rows
  end

  def folder
    if params[:folder_id].present?
      @folder = Folder.find(params[:folder_id])
      @entity = @folder.entity
      @show_steps = false

      if @folder.entity_id == current_user.entity_id
        @documents = policy_scope(Document)
      else
        # Ensure that the IA user has access to the folder, as IAs can only access certain funds/deals etc
        Pundit.policy(current_user, @folder).show? || (@folder.owner && Pundit.policy(current_user, @folder.owner).show?)
        @documents = Document.for_investor(current_user, @folder.entity).not_template
      end

      if params[:no_folders].present?
        @documents = @documents.where(folder_id: params[:folder_id])
      else
        @documents = @documents.joins(:folder).merge(Folder.descendants_of(params[:folder_id]))
        @documents = @documents.or(Document.where(folder_id: params[:folder_id]))
      end
      # Newest docs first
      @documents = @documents.includes(:folder).order(id: :desc)

    else
      # Newest docs first
      @documents = Document.none
    end

    @no_folders = false
    render "index"
  end

  def investor
    if params[:entity_id].present?
      @entity = Entity.find(params[:entity_id])
      @documents = Document.for_investor(current_user, @entity)
    end

    @documents = @documents.order(id: :desc)

    @no_folders = false
    @show_steps = false

    render "index"
  end

  def search
    @entity = params[:entity_id].present? ? Entity.find(params[:entity_id]) : current_user.entity
    query = params[:query]
    if query.present?
      @documents = DocumentIndex.filter(term: { entity_id: @entity.id })
                                .query(query_string: { fields: DocumentIndex::SEARCH_FIELDS,
                                                       query:, default_operator: 'and' })

      @documents = @documents.page(params[:page]).objects
      # @no_folders = true
      render "index"
    else
      redirect_to documents_path
    end
  end

  # GET /documents/1 or /documents/1.json
  def show; end

  def send_for_esign
    if @document.send_for_esign(user_id: current_user.id)
      redirect_to [@document, { tab: "signatures-tab" }], notice: "Document was queued for e-signature."
    else
      redirect_to [@document, { tab: "signatures-tab" }], notice: "Document was NOT sent for e-signature."
    end
  end

  def force_send_for_esign
    if @document.send_for_esign(force: params[:force], user_id: current_user.id)
      redirect_to [@document, { tab: "signatures-tab" }], notice: "Document was queued for e-signature."
    else
      redirect_to [@document, { tab: "signatures-tab" }], notice: "Document was NOT sent for e-signature."
    end
  end

  def send_all_for_esign
    authorize(Document)
    if params[:folder_id].present?
      folder = Folder.find(params[:folder_id])
      authorize(folder, :send_for_esign?)
    end
    DigioEsignJob.perform_later(params[:document_id], current_user.id, folder_id: params[:folder_id])
  end

  # allows to add a button to cancel esigning on document
  def cancel_esign
    if Document::SKIP_ESIGN_UPDATE_STATUSES.exclude?(@document.esign_status)
      DigioEsignHelper.new.update_esign_status(@document)
      @document.reload
    end
    if Document::SKIP_ESIGN_UPDATE_STATUSES.exclude?(@document.esign_status)
      DigioEsignHelper.new.cancel_esign(@document)
      if @document.esign_status.casecmp?("cancelled")
        redirect_to [@document, { tab: "signatures-tab" }], alert: "Document's E-Signature(s) was cancelled"
      else
        redirect_to [@document, { tab: "signatures-tab" }], alert: "Error cancelling E-Signature(s)"
      end
    else
      redirect_to [@document, { tab: "signatures-tab" }], alert: "Document's E-Signature(s) cannot be cancelled"
    end
  end

  def approve
    if request.post?
      options = params.to_unsafe_h.slice(:user_id, :notification, :owner_type, :parent_folder_id)
      options[:user_id] = current_user.id

      DocumentApprovalJob.perform_later(current_user.entity_id, params[:start_date], params[:end_date], options)

      redirect_to documents_path, notice: "Document approval started, please check back in a few mins."
    end
  end

  # GET /documents/new
  def new
    @document = Document.new(document_params)
    @document.setup_folder_defaults
    setup_custom_fields(@document)
    authorize @document
  end

  # GET /documents/1/edit
  def edit
    setup_custom_fields(@document)
  end

  # POST /documents or /documents.json
  def create
    @document = Document.new(document_params)
    @document.entity_id = @document.owner&.entity_id || current_user.entity_id
    @document.user_id = current_user.id
    authorize @document
    respond_to do |format|
      if @document.save
        format.html { save_and_upload }
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
        format.html { save_and_upload }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def save_and_upload
    if params[:commit] == "Save & Upload More"
      fields = %w[entity_id owner_id owner_type description owner_tag orignal download printing]
      dup = @document.duplicate(fields)
      redirect_to new_document_url({ document: dup.attributes.slice(*fields) }), notice: "Document #{@document.name} was successfully saved. Please upload new document below."
    elsif @document.owner
      redirect_to [@document.owner, { tab: "docs-tab" }], notice: "Document was successfully saved."
    else
      redirect_to document_url(@document), notice: "Document was successfully saved."
    end
  end

  # DELETE /documents/1 or /documents/1.json
  def destroy
    @document.destroy

    respond_to do |format|
      format.html do
        if @document.owner
          redirect_to [@document.owner, { tab: "documents-tab" }], notice: "Document was successfully deleted."
        else
          redirect_to documents_url, notice: "Document was successfully deleted."
        end
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.find(params[:id])
    authorize @document
    @bread_crumbs = { Documents: documents_path, "#{@document.name}": document_path(@document) }
  end

  def entity_documents
    # We are trying to get documents that belong to some entity
    @entity = Entity.find(params[:entity_id])
    # Show all the documents for the investor for that entity
    @documents = Document.entity_documents(current_user, @entity.id)
  end

  def owner_documents
    # We are trying to get documents that belong to some entity
    @owner = nil
    if params[:owner_type].present? && params[:owner_id].present?
      # Show all the documents for the owner for that entity
      @owner = params[:owner_type].constantize.find(params[:owner_id])
      @entity = @owner.entity

      @documents = if policy(@owner).show?
                     Document.owner_documents(@owner)
                   else
                     Document.none
                   end
    end
    @show_steps = false
  end

  # Used for bulk actions and index
  def fetch_rows
    if params[:owner_id].present? && params[:owner_type].present?
      # This is typicaly for investors to view documents of a sale, offer, commitment etc
      owner_documents
    else
      # See your own docs
      @entity = current_user.entity
      @q = Document.ransack(params[:q])
      @documents = policy_scope(@q.result)
      authorize(Document)
    end

    if params[:folder_id].present?
      @folder = Folder.find(params[:folder_id])
      @documents = @documents.joins(:folder).merge(Folder.subtree_of(params[:folder_id]))
    end

    # Filter by owner_tag
    @documents = @documents.where(owner_tag: params[:owner_tag]) if params[:owner_tag].present?
    @documents = @documents.where(import_upload_id: params[:import_upload_id]) if params[:import_upload_id].present?
    # This is specifically for non company_admins
    @documents = @documents.where(user_id: current_user.id) unless current_user.has_cached_role?(:company_admin)

    # Newest docs first
    @documents = @documents.includes(:folder).order(id: :desc)
    @documents
  end

  # Only allow a list of trusted parameters through.
  def document_params
    params.require(:document).permit(:name, :text, :entity_id, :video, :form_type_id, :tag_list, :template,
                                     :signature_enabled, :public_visibility, :send_email, :display_on_page,
                                     :download, :printing, :orignal, :owner_id, :owner_type, :owner_tag, :approved,
                                     :tag_list, :folder_id, :file, properties: {}, e_signatures_attributes: %i[id user_id label signature_type notes _destroy], stamp_papers_attributes: %i[id tags sign_on_page notes note_on_page _destroy])
  end
end
