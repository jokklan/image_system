ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Require all factories
Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each { |f| require f }
