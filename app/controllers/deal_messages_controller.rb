class DealMessagesController < ApplicationController
  load_and_authorize_resource :except => ["search"]

  # GET /deal_messages or /deal_messages.json
  def index
    if params[:deal_investor_id]
      @deal_messages = DealMessage.accessible_by(current_ability).where(deal_investor_id: params[:deal_investor_id]) 
    else
      @deal_messages = DealMessage.none
    end
  end

  # GET /deal_messages/1 or /deal_messages/1.json
  def show
  end

  # GET /deal_messages/new
  def new
  end

  # GET /deal_messages/1/edit
  def edit
  end

  # POST /deal_messages or /deal_messages.json
  def create
    @deal_message = DealMessage.new(deal_message_params)
    @deal_message.user_id = current_user.id 

    respond_to do |format|
      if @deal_message.save
        format.html { redirect_to deal_message_url(@deal_message), notice: "Deal message was successfully created." }
        format.json { render :show, status: :created, location: @deal_message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deal_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deal_messages/1 or /deal_messages/1.json
  def update
    respond_to do |format|
      if @deal_message.update(deal_message_params)
        format.html { redirect_to deal_message_url(@deal_message), notice: "Deal message was successfully updated." }
        format.json { render :show, status: :ok, location: @deal_message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deal_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deal_messages/1 or /deal_messages/1.json
  def destroy
    @deal_message.destroy

    respond_to do |format|
      format.html { redirect_to deal_messages_url, notice: "Deal message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal_message
      @deal_message = DealMessage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def deal_message_params
      params.require(:deal_message).permit(:user_id, :content, :deal_investor_id)
    end
end
