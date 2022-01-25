class NotesController < ApplicationController
  load_and_authorize_resource :except => ["search"]

  # GET /notes or /notes.json
  def index
    if params[:investor_id]
      @notes = @notes.where(investor_id: params[:investor_id])
    end

    @notes = @notes.order("notes.id desc")
  end

  def search
    if current_user.is_super?
      @notes = Note.search(params[:query], :star => true)
    else
      @notes = Note.search(params[:query], :star => true, with: {entity_id: current_user.entity_id} )
    end

    render "index"
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new(investor_id: params[:investor_id])
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    @note.entity_id = current_user.entity_id
    
    respond_to do |format|
      if @note.save
        format.html { redirect_to note_url(@note), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to note_url(@note), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy

    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:details, :entity_id, :user_id, :investor_id)
    end
end
