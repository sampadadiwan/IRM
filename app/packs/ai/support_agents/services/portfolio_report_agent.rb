class PortfolioReportAgent < SupportAgentService
  step :initialize_agent
  step :load_document_context
  step :load_section_template
  step :determine_action        # ? ADD THIS
  step :generate_or_refine      # ? RENAME THIS
  step :save_section

  private

  # Initialize agent
  def initialize_agent(ctx, **)
    @support_agent = SupportAgent.find(ctx[:support_agent_id])
    ctx[:support_agent] = @support_agent
  end

  # Load document context (same as before)
  def load_document_context(ctx, **)
    folder_path = ctx[:document_folder_path]
    
    if folder_path.blank?
      Rails.logger.info "[PortfolioReportAgent] No document folder path provided"
      ctx[:documents_context] = ""
      return
    end
    
    Rails.logger.info "[PortfolioReportAgent] Loading documents from: #{folder_path}"
    
    begin
      documents_context = load_documents_from_folder(folder_path)
      ctx[:documents_context] = documents_context
      
      doc_count = documents_context.present? ? documents_context.scan(/=== Document:/).count : 0
      Rails.logger.info "[PortfolioReportAgent] Loaded #{doc_count} documents"
    rescue => e
      Rails.logger.error "[PortfolioReportAgent] Error loading documents: #{e.message}"
      ctx[:documents_context] = ""
    end
  end

  # Load section-specific template
  def load_section_template(ctx, target:, **)
    section = target
    
    ctx[:section] = section
    ctx[:section_type] = section.section_type
    ctx[:template] = get_section_template(section.section_type)
    
    Rails.logger.info "[PortfolioReportAgent] Processing: #{section.section_type}"
  end

  # NEW: Determine if generate or refine
  def determine_action(ctx, action: 'generate',web_search_enabled: false, **)
    ctx[:action] = action
    ctx[:user_prompt] = ctx[:user_prompt] || ""
    ctx[:current_content] = ctx[:current_content] || ""
    ctx[:web_search_enabled] = web_search_enabled
    
    Rails.logger.info "[PortfolioReportAgent] Action: #{action}"
    Rails.logger.info "[PortfolioReportAgent] Web search: #{web_search_enabled}"
  end

  # UPDATED: Generate OR refine based on action
  def generate_or_refine(ctx, **)
    if ctx[:action] == 'refine' && ctx[:current_content].present?
      refine_section_content(ctx)
    else
      generate_section_content(ctx)
    end
  end

  # Generate section content using LLM (existing)
  def generate_section_content(ctx, **)
    section_type = ctx[:section_type]
    template = ctx[:template]
    documents = ctx[:documents_context]
    section = ctx[:section]
    
    report = section.ai_portfolio_report
    company = report.portfolio_company
    
    # Build prompt
    prompt = build_generation_prompt(
      section_type: section_type,
      template: template,
      documents: documents,
      company_name: company.name,
      report_date: report.report_date
    )
    
    # Call LLM
    api_key = ENV['OPENAI_API_KEY']
    raise "OpenAI API key not found" unless api_key

    llm = Langchain::LLM::OpenAI.new(
      api_key: api_key,
      default_options: { 
        chat_completion_model_name: ENV['REPORT_AGENT_MODEL'] || 'gpt-4o',
        temperature: 0.7
      }
    )

    Rails.logger.info "[PortfolioReportAgent] Calling LLM to generate content..."

    response = llm.complete(prompt: prompt)
    content = response.completion

    ctx[:generated_content] = content
    
    Rails.logger.info "[PortfolioReportAgent] Generated #{content.length} characters"
  end

  # NEW: Refine existing content
  def refine_section_content(ctx, **)
    section_type = ctx[:section_type]
    documents = ctx[:documents_context]
    current_content = ctx[:current_content]
    user_prompt = ctx[:user_prompt]
    web_search_enabled = ctx[:web_search_enabled]  # ? ADD THIS
    section = ctx[:section]
    
    report = section.ai_portfolio_report
    company = report.portfolio_company
    
    # Build refinement prompt
    prompt = build_refinement_prompt(
      section_type: section_type,
      current_content: current_content,
      user_prompt: user_prompt,
      documents: documents,
      company_name: company.name,
      web_search_enabled: web_search_enabled  # ? ADD THIS
    )
    
    # Call LLM
    api_key = ENV['OPENAI_API_KEY']
    raise "OpenAI API key not found" unless api_key

    llm = Langchain::LLM::OpenAI.new(
      api_key: api_key,
      default_options: { 
        chat_completion_model_name: ENV['REPORT_AGENT_MODEL'] || 'gpt-4o',
        temperature: 0.7
      }
    )

    Rails.logger.info "[PortfolioReportAgent] Calling LLM to refine content..."

    response = llm.complete(prompt: prompt)
    content = response.completion

    ctx[:generated_content] = content
    
    Rails.logger.info "[PortfolioReportAgent] Refined #{content.length} characters"
  end

  # Save section to database
  def save_section(ctx, section:, generated_content:, **)
    section.update!(
      content_html: generated_content,
      reviewed: false
    )
    
    Rails.logger.info "[PortfolioReportAgent] Section saved successfully"
    
    ctx[:section_id] = section.id
  end

  # == Helper Methods ==

  # Get section-specific template (existing - keep as is)
  def get_section_template(section_type)
    templates = {
      "Company Overview" => {
        description: "Comprehensive company overview including history, mission, and key facts",
        structure: ["Company Background", "Mission & Vision", "Key Milestones", "Current Operations"],
        length: "2-3 paragraphs"
      },
      "Financial Snapshot" => {
        description: "Financial performance summary with key metrics",
        structure: ["Revenue", "Profitability", "Growth Metrics", "Key Ratios"],
        length: "2-3 paragraphs with data points"
      },
      "SWOT Analysis - Blitz" => {
        description: "Strategic analysis of Strengths, Weaknesses, Opportunities, Threats",
        structure: ["Strengths", "Weaknesses", "Opportunities", "Threats"],
        length: "4 sections with 3-5 points each"
      },
      "Key Risks" => {
        description: "Identification and analysis of key business risks",
        structure: ["Market Risks", "Operational Risks", "Financial Risks", "Regulatory Risks"],
        length: "2-3 paragraphs"
      },
      "Competition Analysis" => {
        description: "Competitive landscape and positioning",
        structure: ["Main Competitors", "Competitive Advantages", "Market Position"],
        length: "2-3 paragraphs"
      }
    }
    
    templates[section_type] || {
      description: "Analysis and insights for #{section_type}",
      structure: ["Overview", "Key Points", "Analysis"],
      length: "2-3 paragraphs"
    }
  end

  # Existing generation prompt
  def build_generation_prompt(section_type:, template:, documents:, company_name:, report_date:)
    prompt = <<~PROMPT
      You are a professional investment analyst creating a #{section_type} section for a portfolio company report.
      
      Company: #{company_name}
      Report Date: #{report_date}
      
      #{documents.present? ? "AVAILABLE DOCUMENTS:\n#{documents}\n" : ""}
      
      SECTION REQUIREMENTS:
      Description: #{template[:description]}
      Structure: #{template[:structure].join(', ')}
      Length: #{template[:length]}
      
      CRITICAL - OUTPUT FORMAT:
      - Return ONLY HTML content (no markdown)
      - Use proper HTML tags: <h2>, <h3>, <p>, <ul>, <li>, <strong>, <em>
      - Use <h2> for main section headers
      - Use <h3> for subsections
      - Use <ul><li> for bullet points
      - Use <p> for paragraphs
      - Make it visually professional and well-formatted
      
      INSTRUCTIONS:
      1. Write in professional, analytical tone
      2. Use data from documents when available
      3. Be specific and factual
      4. Format in HTML (NOT markdown)
      5. Include relevant metrics and numbers
      6. #{documents.present? ? "Base analysis on provided documents" : "Use general industry knowledge"}
      
      Generate the #{section_type} section now in HTML format:
    PROMPT
    
    prompt
  end

  def build_refinement_prompt(section_type:, current_content:, user_prompt:, documents:, company_name:, web_search_enabled: false)
  prompt = <<~PROMPT
    You are a professional investment analyst refining a #{section_type} section for a portfolio company report.
    
    Company: #{company_name}
    
    CURRENT CONTENT (HTML):
    #{current_content}
    
    USER REQUEST:
    #{user_prompt}
    
    #{documents.present? ? "AVAILABLE DOCUMENTS FOR REFERENCE:\n#{documents}\n" : ""}
    
    #{web_search_enabled ? "IMPORTANT: Use real-time web search to find the latest information about #{company_name}. Include current news, recent developments, and up-to-date market data.\n" : ""}
    
    CRITICAL - OUTPUT FORMAT:
    - Return ONLY HTML content (no markdown, no code blocks)
    - Use proper HTML tags: <h2>, <h3>, <p>, <ul>, <li>, <strong>, <em>
    - Maintain professional formatting
    
    INSTRUCTIONS:
    1. Carefully read the current content and user request
    2. Apply the requested changes while maintaining professional quality
    3. Preserve important information unless asked to remove it
    4. Add new information if requested
    5. Adjust tone, length, or focus as requested
    6. Use document data if relevant to the request
    #{web_search_enabled ? "7. Search the web for latest information and incorporate recent findings" : ""}
    
    Refine the content according to the user's request now:
  PROMPT
  
  prompt
end

  # Load documents from folder (existing - keep as is)
  def load_documents_from_folder(folder_path)
    return "" unless folder_path.present? && Dir.exist?(folder_path)
    
    documents = []
    supported_extensions = %w[.pdf .txt .md .docx]
    
    Dir.glob(File.join(folder_path, "*")).each do |file_path|
      next unless File.file?(file_path)
      
      extension = File.extname(file_path).downcase
      next unless supported_extensions.include?(extension)
      
      begin
        text = extract_text_from_file(file_path, extension)
        
        documents << {
          name: File.basename(file_path),
          content: text[0..5000]
        }
        
        break if documents.count >= 10
      rescue => e
        Rails.logger.warn "[PortfolioReportAgent] Could not extract: #{file_path}"
      end
    end
    
    format_documents_for_llm(documents)
  end

  # Extract text from file (existing - keep as is)
  def extract_text_from_file(file_path, extension)
    case extension
    when '.txt', '.md'
      File.read(file_path, encoding: 'UTF-8')
    when '.pdf'
      extract_pdf_text(file_path)
    else
      "Cannot extract text from #{extension} files"
    end
  end

  # Extract PDF text (existing - keep as is)
  def extract_pdf_text(file_path)
    require 'pdf-reader'
    
    reader = PDF::Reader.new(file_path)
    text = reader.pages.first(20).map(&:text)
    
    text.join("\n\n")
  rescue => e
    "Error extracting PDF: #{e.message}"
  end

  # Format documents for LLM (existing - keep as is)
  def format_documents_for_llm(documents)
    return "No documents available." if documents.empty?
    
    formatted = documents.map do |doc|
      "=== Document: #{doc[:name]} ===\n#{doc[:content]}\n"
    end
    
    formatted.join("\n---\n\n")
  end
end