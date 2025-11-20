#!/usr/bin/env ruby
# Quick Password Reset Script for IRM_Fresh
# Usage:
# rails runner quick_reset.rb EMAIL [PASSWORD]
# rails runner quick_reset.rb user@example.com newpass123

email = ARGV[0]
new_password = ARGV[1] || "password123"

if email.nil? || email.empty?
  puts "Usage: rails runner quick_reset.rb EMAIL [PASSWORD]"
  puts ""
  puts "Examples:"
  puts " rails runner quick_reset.rb user@example.com"
  puts " rails runner quick_reset.rb user@example.com myNewPass456"
  puts ""
  puts "If password is not provided, default is 'password123'"
  puts ""
  puts "Available users:"
  User.limit(10).each do |u|
    puts " - #{u.email} (#{u.full_name})"
  end
  exit 1
end

user = User.find_by(email: email)

if user.nil?
  puts "❌ User not found: #{email}"
  exit 1
end

user.password = new_password
user.password_confirmation = new_password
user.confirm unless user.confirmed?
user.unlock_access! if user.access_locked?
user.failed_attempts = 0

# Disable Elasticsearch index updates for speed
Chewy.strategy(:bypass) do
  if user.save(validate: false)
    puts "✅ Password reset for #{user.email}"
    puts "   New password: #{new_password}"
  else
    puts "❌ Failed: #{user.errors.full_messages.join(', ')}"
    exit 1
  end
end
