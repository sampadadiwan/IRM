class PythonBackendClient
  include HTTParty

  base_uri ENV.fetch('PYTHON_BACKEND_URL', 'http://localhost:8000')

  def self.chat(message:, section:, web_search_enabled: false)
    post('/api/chat',
         body: {
           message: message,
           section: section,
           web_search_enabled: web_search_enabled
         }.to_json,
         headers: { 'Content-Type' => 'application/json' },
         timeout: 30)
  end

  def self.polish_content(content:, tone: 'professional')
    post('/api/content/polish',
         body: {
           content: content,
           tone: tone
         }.to_json,
         headers: { 'Content-Type' => 'application/json' },
         timeout: 30)
  end

  def self.generate_section(section_type:, company_name:, web_search_enabled: false)
    post('/api/generate-section',
         body: {
           section_type: section_type,
           company_name: company_name,
           web_search_enabled: web_search_enabled
         }.to_json,
         headers: { 'Content-Type' => 'application/json' },
         timeout: 60)
  end

  def self.health_check
    get('/health')
  end

  def self.refine_section(section_type:, current_content:, user_prompt:, web_search_enabled: false)
    post('/api/refine-section',
         body: {
           section_type: section_type,
           current_content: current_content,
           user_prompt: user_prompt,
           web_search_enabled: web_search_enabled
         }.to_json,
         headers: { 'Content-Type' => 'application/json' },
         timeout: 60)
  end
end
