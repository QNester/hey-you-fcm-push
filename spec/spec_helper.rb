require 'bundler/setup'
require 'hey-you'
require 'hey-you-fcm-push'
require 'webmock/rspec'
require 'ffaker'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each {|f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand config.seed

  # config.filter_run :focus

  config.before do
    HeyYou::Config.instance.instance_variable_set(:@configured, false)
    HeyYou::Config.instance_variable_set(:@configured, false)
    HeyYou::Config.instance.instance_variable_set(:@collection, nil)
    HeyYou::Config.instance.instance_variable_set(:@env_collection, nil)
  end
end
