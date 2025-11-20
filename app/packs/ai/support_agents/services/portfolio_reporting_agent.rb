class PortfolioReportingAgent < SupportAgentService
  # PIPELINE STEPS
  step :initialize_agent
  step :check_execution_tag          # Tag-based filtering
  step :fetch_internal_data          # Get investments, KPIs, valuations
  step :fetch_document_metadata      # List available documents
  step :generate_executive_summary   # Create basic summary
  step :generate_progress_reports    # Save to database

  # TARGET SELECTION
  def targets(entity_id)
    Investor.where(entity_id: entity_id, category: "Portfolio Company")
            .includes(:portfolio_investments, :kpi_reports, 
                     :valuations, :documents)
  end

  private

  # STEP 1: Initialize agent
  def initialize_agent(ctx, target:, **)
    super
    
    portfolio_company = target
    ctx[:portfolio_company] = portfolio_company
    
    # Initialize report structure
    ctx[:report_sections] = {
      executive_summary: {},
      charts: [],
      founders_shareholders: {},
      investment_thesis: {},
      key_risks: {},
      valuation_insights: {},
      industry_note: {},
      metadata: {
        generated_at: Time.current,
        agent_version: "1.0.0",
        portfolio_company_id: portfolio_company.id,
        portfolio_company_name: portfolio_company.investor_name
      }
    }
    
    ctx[:issues] = {
      missing_data: [],
      warnings: [],
      errors: []
    }
    
    portfolio_company.category == "Portfolio Company" && 
      @support_agent.enabled?
  end

  # STEP 2: Check execution tag (optional filtering)
  def check_execution_tag(ctx, portfolio_company:, **)
    execution_tag = @support_agent.json_fields["execution_tag"]
    
    return true if execution_tag.blank?
    
    company_tags = portfolio_company.tags&.pluck(:name) || []
    
    if company_tags.include?(execution_tag)
      Rails.logger.debug "Tag match found"
      true
    else
      ctx[:issues][:warnings] << {
        type: :tag_mismatch,
        message: "Portfolio company missing tag: #{execution_tag}",
        severity: :info
      }
      false  # Stop execution
    end
  end

  # STEP 3: Fetch internal data
  def fetch_internal_data(ctx, portfolio_company:, **)
    Rails.logger.debug "Fetching internal data"
    
    portfolio_investments = portfolio_company.portfolio_investments
                                              .order(investment_date: :desc)
    
    ctx[:internal_data] = {
      portfolio_investments: portfolio_investments,
      total_investment: portfolio_investments.sum(:amount_cents) / 100.0,
      latest_valuation: portfolio_company.valuations
                                         .order(valuation_date: :desc)
                                         .first,
      kpi_reports_count: portfolio_company.kpi_reports.count,
      latest_kpi_report: portfolio_company.kpi_reports
                                          .order(as_of: :desc)
                                          .first
    }
    
    # Track missing data
    if portfolio_investments.empty?
      ctx[:issues][:missing_data] << {
        type: :no_investments,
        message: "No portfolio investments found",
        severity: :warning
      }
    end
    
    true
  end

  # STEP 4: Fetch document metadata
  def fetch_document_metadata(ctx, portfolio_company:, **)
    documents = portfolio_company.documents
    
    ctx[:documents] = {
      deck: documents.select { |d| 
        d.name.downcase.include?("deck") || 
        d.name.downcase.include?("presentation") 
      },
      financials_csv: documents.select { |d| 
        d.name.downcase.include?("financial") && 
        d.file.content_type == "text/csv" 
      },
      dd_report: documents.select { |d| 
        d.name.downcase.include?("due diligence") 
      },
      annual_report: documents.select { |d| 
        d.name.downcase.include?("annual report") 
      },
      other: []
    }
    
    total_docs = ctx[:documents].values.flatten.count
    
    ctx[:report_sections][:metadata][:documents_found] = {
      deck: ctx[:documents][:deck].count,
      financials_csv: ctx[:documents][:financials_csv].count,
      dd_report: ctx[:documents][:dd_report].count,
      annual_report: ctx[:documents][:annual_report].count,
      total: total_docs
    }
    
    true
  end

  # STEP 5: Generate executive summary
  def generate_executive_summary(ctx, portfolio_company:, **)
    internal_data = ctx[:internal_data]
    
    executive_summary = {
      company_name: portfolio_company.investor_name,
      company_overview: portfolio_company.description || "N/A",
      
      total_investment: {
        amount: internal_data[:total_investment],
        currency: portfolio_company.entity.currency,
        investments_count: internal_data[:portfolio_investments].count
      },
      
      latest_valuation: if internal_data[:latest_valuation]
        {
          value: internal_data[:latest_valuation].value,
          date: internal_data[:latest_valuation].valuation_date,
          method: internal_data[:latest_valuation].valuation_method
        }
      else
        "No valuation data available"
      end,
      
      kpi_summary: {
        reports_count: internal_data[:kpi_reports_count],
        latest_report_date: internal_data[:latest_kpi_report]&.as_of || "N/A"
      },
      
      data_completeness: calculate_data_completeness(ctx)
    }
    
    ctx[:report_sections][:executive_summary] = executive_summary
    true
  end

  # STEP 6: Save report
  def generate_progress_reports(ctx, portfolio_company:, support_agent:, **)
    report = SupportAgentReport.find_or_initialize_by(
      owner: portfolio_company,
      support_agent: support_agent
    )
    
    report.json_fields = {
      report_sections: ctx[:report_sections],
      issues: ctx[:issues],
      internal_data_summary: {
        investments_count: ctx[:internal_data][:portfolio_investments].count,
        total_investment: ctx[:internal_data][:total_investment],
        has_valuation: ctx[:internal_data][:latest_valuation].present?,
        has_kpis: ctx[:internal_data][:kpi_reports_count] > 0
      },
      documents_summary: ctx[:report_sections][:metadata][:documents_found]
    }
    
    report.save!
    ctx[:support_agent_report] = report
    report.valid?
  end

  # Helper: Calculate data completeness
  def calculate_data_completeness(ctx)
    total_items = 4
    complete_items = 0
    
    complete_items += 1 if ctx[:internal_data][:portfolio_investments].any?
    complete_items += 1 if ctx[:internal_data][:latest_valuation].present?
    complete_items += 1 if ctx[:internal_data][:kpi_reports_count] > 0
    complete_items += 1 if ctx[:documents].values.flatten.any?
    
    ((complete_items.to_f / total_items) * 100).round
  end
end