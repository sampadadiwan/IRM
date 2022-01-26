class InvestorAccessesController < ApplicationController
  load_and_authorize_resource :except => ["search"]

  # GET /investor_accesses or /investor_accesses.json
  def index
    @investor_accesses = @investor_accesses.joins(:investor).
                          includes(:investor).page params[:page]
  end

  # GET /investor_accesses/1 or /investor_accesses/1.json
  def show
  end

  def search
    @entity = current_user.entity
    if current_user.is_super?
      @investor_accesses = InvestorAccess.search(params[:query], :star => true)
    else
      @investor_accesses = InvestorAccess.search(params[:query], :star => true, with: {:entity_id => current_user.entity_id})
    end

    render "index"
  end


  # GET /investor_accesses/new
  def new
    @investor_access = InvestorAccess.new(investor_id: investor_access_params[:investor_id])
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append('new_investor_access', partial: "investor_accesses/form", locals: {investor_access: @investor_access})
        ]
      end
      format.html 
    end
  end

  # GET /investor_accesses/1/edit
  def edit
  end

  # POST /investor_accesses or /investor_accesses.json
  def create
    @investor_access = InvestorAccess.new(investor_access_params)
    @investor_access.granted_by = current_user.id
    @investor_access.entity_id = current_user.entity_id
    
    respond_to do |format|
      if @investor_access.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append('investor_accesses_table', partial: "investor_accesses/investor_access", locals: {investor_access: @investor_access})
          ]
        end
        
        format.html { redirect_to investor_access_url(@investor_access), notice: "Investor access was successfully created." }
        format.json { render :show, status: :created, location: @investor_access }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @investor_access.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /investor_accesses/1 or /investor_accesses/1.json
  def update
    respond_to do |format|
      if @investor_access.update(investor_access_params)
        format.html { redirect_to investor_access_url(@investor_access), notice: "Investor access was successfully updated." }
        format.json { render :show, status: :ok, location: @investor_access }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @investor_access.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /investor_accesses/1 or /investor_accesses/1.json
  def destroy
    @investor_access.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@investor_access)
        ]
      end
      
      format.html { redirect_to investor_accesses_url, notice: "Investor access was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_investor_access
      @investor_access = InvestorAccess.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def investor_access_params
      params.require(:investor_access).permit(:investor_id, :email, :access_type, :granted_by)
    end
end
