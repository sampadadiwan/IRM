class PythonBackendClient
  include HTTParty
  base_uri ENV.fetch('PYTHON_BACKEND_URL', 'http://localhost:8000')
  
  def self.chat(message:, section:)
    post('/api/chat', 
      body: { 
        message: message, 
        section: section 
      }.to_json,
      headers: { 'Content-Type' => 'application/json' },
      timeout: 30
    )
  end
  
  def self.polish_content(content:, tone: 'professional')
    post('/api/content/polish',
      body: {
        content: content,
        tone: tone
      }.to_json,
      headers: { 'Content-Type' => 'application/json' },
      timeout: 30
    )
  end
  
  def self.health_check
    get('/health')
  end
end
