# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require ::File.expand_path('../../../config/environment', __dir__)
abort('The Rails environment is not running in test mode!') unless Rails.env.test?
require 'rspec/rails'

RSpec.configure do |config|
  config.fixture_path = ::Rails.root.join('test', 'fixtures')

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.use_transactional_fixtures = true
end

require 'capybara/rspec'
require 'rack_session_access/capybara'

def test_config_class(plugin_name)
  ::Object.const_get(plugin_name.to_s.camelcase).const_get('TestConfig')
rescue ::NameError
  nil
end

def test_config_instance(plugin_name)
  klass = test_config_class(plugin_name)
  klass ? klass.new : nil
end

::Redmine::Plugin.registered_plugins.each_key do |plugin|
  instance = test_config_instance(plugin)
  next unless instance

  RSpec.configure do |config|
    %i[before after].each do |prefix|
      %i[each all].each do |suffix|
        method = "#{prefix}_#{suffix}".to_sym
        config.send(prefix, suffix) { instance.send(method) } if instance.respond_to?(method)
      end
    end
  end
end
