class DealDocsController < ApplicationController
  before_action :set_deal_doc, only: %w[show update destroy edit update_sequence toggle_completed]

  # GET /deal_docs or /deal_docs.json
  def index
    @deal_docs = if params[:deal_investor_id]
                   DealDoc.accessible_by(current_ability).where(deal_investor_id: params[:deal_investor_id])
                 elsif params[:deal_id]
                   DealDoc.accessible_by(current_ability).where(deal_id: params[:deal_id])
                 elsif params[:deal_activity_id]
                   DealDoc.accessible_by(current_ability).where(deal_activity_id: params[:deal_activity_id])
                 else
                   DealDoc.none
                 end
  end

  # GET /deal_docs/1 or /deal_docs/1.json
  def show; end

  # GET /deal_docs/new
  def new
    @deal_doc = DealDoc.new(deal_doc_params)
    authorize @deal_doc
  end

  # GET /deal_docs/1/edit
  def edit; end

  # POST /deal_docs or /deal_docs.json
  def create
    @deal_doc = DealDoc.new(deal_doc_params)
    @deal_doc.user_id = current_user.id
    authorize @deal_doc

    respond_to do |format|
      if @deal_doc.save
        format.html { redirect_to deal_doc_url(@deal_doc), notice: "Deal doc was successfully created." }
        format.json { render :show, status: :created, location: @deal_doc }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deal_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deal_docs/1 or /deal_docs/1.json
  def update
    respond_to do |format|
      if @deal_doc.update(deal_doc_params)
        format.html { redirect_to deal_doc_url(@deal_doc), notice: "Deal doc was successfully updated." }
        format.json { render :show, status: :ok, location: @deal_doc }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deal_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deal_docs/1 or /deal_docs/1.json
  def destroy
    @deal_doc.destroy

    respond_to do |format|
      format.html { redirect_to deal_docs_url, notice: "Deal doc was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_deal_doc
    @deal_doc = DealDoc.find(params[:id])
    authorize @deal_doc
  end

  # Only allow a list of trusted parameters through.
  def deal_doc_params
    params.require(:deal_doc).permit(:name, :file, :deal_id, :deal_investor_id, :deal_activity_id, :user_id)
  end
end
