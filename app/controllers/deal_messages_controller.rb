class DealMessagesController < ApplicationController
  before_action :set_deal_activity, :only => ["show", "update", "destroy", "edit"] 

  # GET /deal_messages or /deal_messages.json
  def index

    @deal_messages = policy_scope(DealMessage)
    if params[:deal_investor_id]
      @deal_investor = DealInvestor.find(params[:deal_investor_id])
      @deal_messages = @deal_messages.where(deal_investor_id: params[:deal_investor_id]) 
    else
      @deal_messages = DealMessage.none
    end
  end

  # GET /deal_messages/1 or /deal_messages/1.json
  def show
    authorize @deal_message
  end

  # GET /deal_messages/new
  def new
    authorize @deal_message
  end

  # GET /deal_messages/1/edit
  def edit
    authorize @deal_message
  end

  # POST /deal_messages or /deal_messages.json
  def create
    @deal_message = DealMessage.new(deal_message_params)
    @deal_message.user_id = current_user.id 
    authorize @deal_message

    respond_to do |format|
      if @deal_message.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('deal_message_form', partial: "deal_messages/form", 
                locals: {deal_message: DealMessage.new(deal_investor_id: @deal_message.deal_investor_id)})
          ]
        end
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
    authorize @deal_message

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
    authorize @deal_message
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
