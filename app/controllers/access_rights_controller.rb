class AccessRightsController < ApplicationController
  load_and_authorize_resource :except => ["search"]

  # GET /access_rights or /access_rights.json
  def index
  end


  def search
    @entity = current_user.entity
    @access_rights = AccessRight.search(params[:query], :star => false, with: {:entity_id => current_user.entity_id})
    render "index"
  end


  # GET /access_rights/1 or /access_rights/1.json
  def show
  end

  # GET /access_rights/new
  def new
    @access_right = AccessRight.new(access_right_params)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append('new_access_right', partial: "access_rights/form", locals: {access_right: @access_right, hide_owner: true})
        ]
      end
      format.html 
    end
  end

  # GET /access_rights/1/edit
  def edit
  end

  # POST /access_rights or /access_rights.json
  def create
    @access_right = AccessRight.new(access_right_params)
    @access_right.entity_id = current_user.entity_id

    respond_to do |format|
      if @access_right.save   
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend('access_rights_table_body', partial: "access_rights/access_right", locals: {access_right: @access_right})
          ]
        end
             
        format.html { redirect_to access_right_url(@access_right), notice: "Access right was successfully created." }
        format.json { render :show, status: :created, location: @access_right }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @access_right.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /access_rights/1 or /access_rights/1.json
  def update
    @access_right.entity_id = current_user.entity_id    
    respond_to do |format|
      if @access_right.update(access_right_params)
        format.html { redirect_to access_right_url(@access_right), notice: "Access right was successfully updated." }
        format.json { render :show, status: :ok, location: @access_right }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @access_right.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /access_rights/1 or /access_rights/1.json
  def destroy
    @access_right.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@access_right)
        ]
      end
      format.html { redirect_to access_rights_url, notice: "Access right was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access_right
      @access_right = AccessRight.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def access_right_params
      params.require(:access_right).permit(:owner_id, :owner_type, :access_to, 
        :access_to_investor_id, :access_type, :metadata)
    end
end
