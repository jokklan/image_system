def zeus_running?
  File.exists? '.zeus.sock'
end

if !zeus_running?
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
end
