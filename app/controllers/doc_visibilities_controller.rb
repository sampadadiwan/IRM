class DocVisibilitiesController < ApplicationController
  load_and_authorize_resource
  
  # GET /doc_visibilities or /doc_visibilities.json
  def index
    @doc_visibilities = DocVisibility.all
  end

  # GET /doc_visibilities/1 or /doc_visibilities/1.json
  def show
  end

  # GET /doc_visibilities/new
  def new
    @doc_visibility = DocVisibility.new(doc_visibility_params)
  end

  # GET /doc_visibilities/1/edit
  def edit
  end

  # POST /doc_visibilities or /doc_visibilities.json
  def create
    @doc_visibility = DocVisibility.new(doc_visibility_params)

    respond_to do |format|
      if @doc_visibility.save
        format.html { redirect_to document_url(@doc_visibility.document), notice: "Doc visibility was successfully created." }
        format.json { render :show, status: :created, location: @doc_visibility }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @doc_visibility.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_visibilities/1 or /doc_visibilities/1.json
  def update
    respond_to do |format|
      if @doc_visibility.update(doc_visibility_params)
        format.html { redirect_to document_url(@doc_visibility.document), notice: "Doc visibility was successfully updated." }
        format.json { render :show, status: :ok, location: @doc_visibility }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @doc_visibility.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_visibilities/1 or /doc_visibilities/1.json
  def destroy
    @doc_visibility.destroy

    respond_to do |format|
      format.html { redirect_to doc_visibilities_url, notice: "Doc visibility was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_visibility
      @doc_visibility = DocVisibility.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def doc_visibility_params
      params.require(:doc_visibility).permit(:document_id, :visiblity_type, :to)
    end
end
