# config/initializers/python_backend.rb
PYTHON_BACKEND_URL = ENV.fetch('PYTHON_BACKEND_URL', 'http://localhost:8000')

# Simple wrapper for Python API calls
class PythonBackendClient
  include HTTParty

  base_uri PYTHON_BACKEND_URL

  def self.chat(message:, section:)
    post('/api/chat',
         body: {
           message: message,
           section: section
         }.to_json,
         headers: { 'Content-Type' => 'application/json' })
  end

  def self.polish_content(content:, tone: 'professional')
    post('/api/content/polish',
         body: {
           content: content,
           tone: tone
         }.to_json,
         headers: { 'Content-Type' => 'application/json' })
  end

  def self.generate_section(section_type:, company_name:)
    post('/api/generate-section',
         body: {
           section_type: section_type,
           company_name: company_name
         }.to_json,
         headers: { 'Content-Type' => 'application/json' },
         timeout: 60)
  end

  def self.refine_section(section_type:, current_content:, user_prompt:)
    post('/api/refine-section',
         body: {
           section_type: section_type,
           current_content: current_content,
           user_prompt: user_prompt
         }.to_json,
         headers: { 'Content-Type' => 'application/json' },
         timeout: 60)
  end
end
