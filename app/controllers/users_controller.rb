class UsersController < ApplicationController
  load_and_authorize_resource :except => ["search"]

  # GET /users or /users.json
  def index
  end

  def search
    if current_user.is_super?
      @users = User.search(params[:query], :star => true)
    else
      @users = User.search(params[:query], :star => true, :with => {:entity_id => current_user.entity_id})
    end

    render "index"
  end


  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
    @user.entity_id = params[:entity_id]
  end

  # GET /users/1/edit
  def edit; end

  
  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone)
  end
end
