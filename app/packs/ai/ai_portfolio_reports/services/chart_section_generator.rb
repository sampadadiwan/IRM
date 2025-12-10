# app/packs/ai/ai_portfolio_reports/services/chart_section_generator.rb
class ChartSectionGenerator
  def initialize(report:, section:)
    @report = report
    @section = section
    @portfolio_company = report.portfolio_company
    @entity = @portfolio_company.entity
  end

  # Main method: Generate charts and return HTML
  def generate_charts_html
    # Clear any existing charts
    @section.agent_chart_ids = []
    
    # Define chart prompts (similar to your Python backend)
    chart_prompts = [
      "Revenue trend over last 4 quarters - show quarterly revenue growth as a line chart",
      "Customer acquisition metrics - show monthly new customers as a bar chart",
      "Operating expenses breakdown by category - show as a pie chart"
    ]
    
    # Find relevant CSV documents
    csv_paths = find_csv_documents
    
    Rails.logger.info "=== Chart Generation Started ==="
    Rails.logger.info "Company: #{@portfolio_company.name}"
    Rails.logger.info "CSV files found: #{csv_paths.count}"
    
    # Generate each chart
    charts_html = ""
    chart_prompts.each_with_index do |prompt, index|
      begin
        chart = create_chart(prompt, csv_paths, index + 1)
        @section.add_chart(chart)
        charts_html += chart_to_html(chart)
      rescue StandardError => e
        Rails.logger.error "Failed to generate chart #{index + 1}: #{e.message}"
        charts_html += error_chart_html(prompt, e.message)
      end
    end
    
    # Save the section
    @section.save
    
    Rails.logger.info "Generated #{@section.agent_chart_ids.count} charts"
    
    charts_html
  end

  # Add this new method after generate_charts_html
def add_chart_from_prompt(user_prompt:)
  # Find relevant CSV documents
  csv_paths = find_csv_documents
  
  Rails.logger.info "=== Adding Chart from Prompt ==="
  Rails.logger.info "User prompt: #{user_prompt}"
  Rails.logger.info "Documents found: #{csv_paths.count}"
  
  # Determine next chart number
  existing_charts = @section.agent_charts.count
  chart_number = existing_charts + 1
  
  # Create single chart based on user prompt
  begin
    chart = create_chart(user_prompt, csv_paths, chart_number)
    @section.add_chart(chart)
    
    Rails.logger.info "Added chart: #{chart.title}"
    
    # Return HTML for just this new chart
    chart_to_html(chart)
  rescue StandardError => e
    Rails.logger.error "Failed to add chart: #{e.message}"
    error_chart_html(user_prompt, e.message)
  end
end

# Update the generate_charts_html method to accept custom prompts
def generate_charts_html(chart_prompts: nil)
  # Clear any existing charts
  @section.agent_chart_ids = []
  
  # Use provided prompts or default ones
  prompts = chart_prompts || [
    "Revenue trend over last 4 quarters - show quarterly revenue growth as a line chart",
    "Customer acquisition metrics - show monthly new customers as a bar chart",
    "Operating expenses breakdown by category - show as a pie chart"
  ]
  
  # Find relevant CSV documents
  csv_paths = find_csv_documents
  
  Rails.logger.info "=== Chart Generation Started ==="
  Rails.logger.info "Company: #{@portfolio_company.name}"
  Rails.logger.info "CSV files found: #{csv_paths.count}"
  
  # Generate each chart
  charts_html = ""
  prompts.each_with_index do |prompt, index|
    begin
      chart = create_chart(prompt, csv_paths, index + 1)
      @section.add_chart(chart)
      charts_html += chart_to_html(chart)
    rescue StandardError => e
      Rails.logger.error "Failed to generate chart #{index + 1}: #{e.message}"
      charts_html += error_chart_html(prompt, e.message)
    end
  end
  
  # Save the section
  @section.save
  
  Rails.logger.info "Generated #{@section.agent_chart_ids.count} charts"
  
  charts_html
end

  private

  # Create a single chart using AgentChart + ChartAgentService
  def create_chart(prompt, csv_paths, chart_number)
    chart = AgentChart.create!(
      entity_id: @entity.id,
      title: "Chart #{chart_number}: #{extract_title(prompt)}",
      prompt: prompt,
      status: 'draft',
      owner: @report
    )

    # Copy files to safe temp location so ChartAgentService can delete them
    temp_csv_paths = []
    csv_paths.each do |original_path|
      temp_file = Tempfile.new(['chart_data', File.extname(original_path)])
      FileUtils.cp(original_path, temp_file.path)
      temp_csv_paths << temp_file.path
    end
    
    # Generate the chart spec using existing ChartAgentService
    chart.generate_spec!(csv_paths: temp_csv_paths)
    
    chart
  end

  # Convert chart to HTML in YOUR Python format (so frontend doesn't change!)
  def chart_to_html(chart)
    spec = chart.spec
    
    # Extract chart type and data
    chart_type = spec['type'] || 'bar'
    chart_data = spec['data'] || {}
    
    <<~HTML
      <div style="margin-bottom: 30px; padding: 20px; border: 1px solid #dee2e6; border-radius: 8px; background: #f8f9fa;">
        <h4>#{chart.title}</h4>
        <p><em>#{chart.prompt}</em></p>
        <div class="chart-placeholder" 
             data-chart-config='#{chart_data.to_json}' 
             data-chart-type='#{chart_type}'
             style="background: white; padding: 20px; border-radius: 4px; min-height: 300px;">
        </div>
      </div>
    HTML
  end

  # Error fallback HTML
  def error_chart_html(prompt, error_message)
    <<~HTML
      <div style="margin-bottom: 30px; padding: 20px; border: 1px solid #dc3545; border-radius: 8px; background: #f8d7da;">
        <h4>?? Chart Generation Failed</h4>
        <p><em>#{prompt}</em></p>
        <p style="color: #721c24;">Error: #{error_message}</p>
      </div>
    HTML
  end

  # Find CSV documents for this portfolio company
  # Find relevant documents (CSV, TXT, MD, PDF, DOCX) for this portfolio company
  # Find relevant documents from demo_documents folder (like Python backend)
  def find_csv_documents
    document_paths = []
    
      # Supported file types for chart generation
    supported_extensions = ['.csv', '.txt', '.md', '.pdf', '.docx', '.doc']
    
    Rails.logger.info "=== Searching for documents ==="
    
    # Use same path as GenerateSectionContentJob
    demo_docs_path = Pathname.new('/tmp/test_documents')
    
    if demo_docs_path.exist?
      Rails.logger.info "Checking folder: #{demo_docs_path}"
      
      supported_extensions.each do |ext|
        Dir.glob(demo_docs_path.join("*#{ext}")).each do |file_path|
          document_paths << file_path
          Rails.logger.info "  ? Found: #{File.basename(file_path)}"
        end
      end
    else
      Rails.logger.warn "demo_documents folder not found at: #{demo_docs_path}"
      Rails.logger.info "Creating demo_documents folder..."
      FileUtils.mkdir_p(demo_docs_path)
    end
    
    Rails.logger.info "Total documents found: #{document_paths.count}"
    document_paths
  end

  # Extract text content from different document types
  def extract_text_from_document(doc, extension)
    case extension
    when '.txt', '.md'
      # Plain text - just read it
      doc.file.download
      
    when '.pdf'
      # Extract text from PDF
      require 'pdf-reader'
      reader = PDF::Reader.new(StringIO.new(doc.file.download))
      reader.pages.map(&:text).join("\n")
      
    when '.docx', '.doc'
      # Extract text from Word document
      require 'docx'
      temp_file = Tempfile.new(['doc', extension])
      temp_file.binmode
      temp_file.write(doc.file.download)
      temp_file.close
      
      docx = Docx::Document.open(temp_file.path)
      text = docx.paragraphs.map(&:text).join("\n")
      temp_file.unlink
      text
      
    else
      # Fallback: try to read as text
      doc.file.download
    end
  rescue StandardError => e
    Rails.logger.error "Failed to extract text from #{extension}: #{e.message}"
    "[Document content could not be extracted]"
  end

  # Extract a short title from the prompt
  def extract_title(prompt)
    # Take first part before dash or hyphen
    title = prompt.split(/[-]/).first.strip
    # Limit to 50 characters
    title.truncate(50)
  end
end