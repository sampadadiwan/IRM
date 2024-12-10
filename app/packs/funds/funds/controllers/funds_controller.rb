class FundsController < ApplicationController
  before_action :set_fund, only: %i[show dashboard edit update destroy last report generate_fund_ratios allocate_form allocate copy_formulas export generate_documentation check_access_rights delete_all generate_reports]

  # GET /funds or /funds.json
  def index
    @q = Fund.ransack(params[:q])
    @funds = policy_scope(@q.result).includes(:entity)
    @funds = @funds.where(entity_id: params[:entity_id]) if params[:entity_id].present?
    @funds = @funds.where("funds.tag_list LIKE ?", "%#{params[:tag]}%") if params[:tag].present?
    @funds = @funds.page(params[:page]) if params[:card].present? || params[:all].present?
  end

  def export
    export_file = FundXlExport.new.generate(@fund)
    send_file export_file, type: "application/vnd.ms-excel", filename: "#{@fund.name}.xlsx", stream: false
    # File.delete(export_file)
  end

  def report
    if params[:report].present? && params[:report] == "generate_reports"
      XlReportJob.perform_later(@fund.id, current_user.id)
      redirect_to fund_path(@fund), notice: "Report generation started, please check back in a few mins. Your report will be generated in the 'Fund Reports' folder."
    elsif params[:report].present? && params[:report].split('/').last.casecmp?("sebi_report")
      if @fund.documents.where("documents.name LIKE ?", "SEBI Report%").present?
        doc = @fund.documents.where("documents.name LIKE ?", "SEBI Report%").last
        redirect_to document_path(doc)
      else
        FundReportJob.perform_later(@fund.entity_id, @fund.id, "SEBI Report", Time.zone.today - 3.months, Time.zone.today, current_user.id)
        redirect_to fund_path(@fund), notice: "SEBI Report generation started, please check back in a few mins"
      end
    else
      @fund_report = FundReport.find(params[:fund_report_id]) if params[:fund_report_id].present?
      @fund_report ||= FundReport.where(fund_id: @fund.id, name: params[:report].split('/').last.camelize).last
      @bread_crumbs = { Funds: funds_path, "#{@fund.name}": fund_path(@fund), 'Fund Reports': fund_reports_path(fund_id: @fund.id), "#{params[:report].split('/').last.camelize}": report_fund_path(@fund, fund_report_id: @fund_report.id, report: params[:report].to_s) } if @fund_report.present?
      render "/funds/#{params[:report]}"
    end
  end

  def generate_reports
    if request.post?
      # Generate the report if this is a post request
      FundLlmReportJob.perform_later(
        @fund.id, current_user.id, params[:report_type],
        report_template_name: params[:report_template_name],
        start_date: params[:start_date], end_date: params[:end_date]
      )

      redirect_to fund_path(@fund, tab: 'portfolio-investments-tab'), notice: "Report generation started, please check back in a few mins"
    else
      # Show the form to generate the report
      render "generate_reports"
    end
  end

  def check_access_rights
    if params[:create_missing] == "true"
      FundAccessRightsJob.perform_later(@fund.id, true, current_user.id)
      redirect_to fund_path(@fund), notice: "AccessRights creation started, please check back in a few mins"
    else
      cars = @fund.check_access_rights
      redirect_to fund_path(@fund), notice: "Missing Access Rights #{cars.length} : #{cars}"
    end
  end

  # GET /funds/1 or /funds/1.json
  def show; end

  def dashboard
    respond_to do |format|
      format.html
      format.pdf do
        FerrumPdf.browser(timeout: 180)
        pdf = render_pdf
        send_data pdf, disposition: :inline, filename: "#{@fund.name}.pdf"
      end
    end
  end

  # GET /funds/new
  def new
    @fund = Fund.new
    @fund.entity_id = current_user.entity_id
    @fund.currency = @fund.entity.currency
    setup_custom_fields(@fund)
    authorize(@fund)
  end

  # GET /funds/1/edit
  def edit
    setup_custom_fields(@fund)
  end

  def last
    cc = nil
    cc = @fund.capital_calls.order(due_date: :asc).last if params[:entry] == "CapitalCall"
    if cc
      redirect_to capital_call_path(id: cc.id, tab: "remittances-tab")
    else
      redirect_to fund_path(id: @fund.id, tab: "capital-calls-tab")
    end
  end

  # POST /funds or /funds.json
  def create
    @fund = Fund.new(fund_params)
    authorize(@fund)
    respond_to do |format|
      if @fund.save
        format.html { redirect_to fund_url(@fund), notice: "Fund was successfully created." }
        format.json { render :show, status: :created, location: @fund }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fund.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /funds/1 or /funds/1.json
  def update
    respond_to do |format|
      if @fund.update(fund_params)
        format.html { redirect_to fund_url(@fund), notice: "Fund was successfully updated." }
        format.json { render :show, status: :ok, location: @fund }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fund.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_all
    delete_class_name = params[:type]
    FundDeleteAllJob.perform_later(@fund.id, delete_class_name, current_user.id)
    redirect_to fund_path(@fund), notice: "Deletion of #{delete_class_name} started, please check back in a few mins"
  end

  def generate_fund_ratios
    if params[:end_date].present?
      generate_for_commitments = params[:generate_for_commitments] == "1"
      @fund.generate_fund_ratios(current_user.id, Date.parse(params[:end_date]), generate_for_commitments:)
      redirect_to fund_path(@fund, tab: "fund-ratios-tab"), notice: "Calculations in progress, please check back in a few mins."
    else
      render "generate_fund_ratios"
    end
  end

  def generate_documentation
    CapitalCommitmentDocJob.perform_later(@fund.id, nil, current_user.id, template_id: params[:template_id])
    redirect_to fund_path(@fund), notice: "Documentation generation started, please check back in a few mins."
  end

  # DELETE /funds/1 or /funds/1.json
  def destroy
    @fund.destroy

    respond_to do |format|
      format.html { redirect_to funds_url, notice: "Fund was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def allocate_form; end

  def allocate
    start_date = nil
    end_date = nil

    begin
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      template_name = params[:template_name]
      generate_soa = params[:generate_soa] == "1"
      fund_ratios = params[:fund_ratios] == "1"
      run_allocations = params[:run_allocations] == "1"
      explain = params[:explain] == "1"
      sample = params[:sample] == "true"
      rule_for = params[:rule_for]
      tag_list = nil
      tag_list = params[:tag_list].join(",") if params[:tag_list].present? && params[:tag_list].is_a?(Array)
      user_id = current_user.id

      if params["run_allocations"]
        existing_allocation_run = AllocationRun.locked_and_overlapping(@fund.id, start_date, end_date)
        if existing_allocation_run
          flash[:alert] = "This AllocationRun already exists for the specified period and is locked. Start Date - #{existing_allocation_run.start_date.strftime('%d-%m-%Y')} and End Date - #{existing_allocation_run.end_date.strftime('%d-%m-%Y')}."
          redirect_back(fallback_location: root_path) and return
        end
      end

      allocation_run = AllocationRun.create!(entity_id: @fund.entity_id, fund_id: @fund.id, start_date:, end_date:, run_allocations:, generate_soa:, template_name:, fund_ratios:, user_id: current_user.id, rule_for:, tag_list:)
    rescue StandardError
      Rails.logger.debug "allocate: Dates not sent properly"
      redirect_back(fallback_location: root_path, alert: "Please specify the start_date and end_date for allocation.")
      return
    end

    if start_date.present? && end_date.present?
      AccountEntryAllocationJob.perform_later(@fund.id, start_date, end_date, rule_for:, tag_list:, run_allocations:, explain:, user_id:, generate_soa:, template_name:, fund_ratios:, sample:, allocation_run_id: allocation_run.id)
      redirect_to(@fund, notice: "Fund account entries allocation in progress. Please wait for a few minutes and refresh the page.")
    else
      redirect_back(fallback_location: root_path, alert: "Please specify the start_date and end_date for allocation.")
    end
  end

  def copy_formulas
    from_fund = Fund.find(params[:from_fund_id])

    from_fund.fund_formulas.order(sequence: :asc).each do |ff|
      new_ff = ff.dup
      new_ff.fund = @fund
      new_ff.entity_id = @fund.entity_id
      new_ff.save
    end

    redirect_back(fallback_location: fund_path(@fund), notice: "Formulas copied successfully.")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fund
    @fund = Fund.find(params[:id])
    authorize(@fund)
    @bread_crumbs = { Funds: funds_path, "#{@fund.name}": fund_path(@fund) }
  end

  # Only allow a list of trusted parameters through.
  def fund_params
    params.require(:fund).permit(:name, :committed_amount, :details, :collected_amount, :commitment_doc_list,
                                 :entity_id, :tag_list, :show_valuations, :show_fund_ratios,
                                 :currency, :unit_types, :units_allocation_engine, :form_type_id, :first_close_date,
                                 :registration_number, :category, :sub_category, :sponsor_name, :manager_name,
                                 :trustee_name, :contact_name, :contact_email, :show_portfolios, :last_close_date,
                                 :esign_emails, documents_attributes: Document::NESTED_ATTRIBUTES, properties: {})
  end
end
