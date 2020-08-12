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

require 'eac_ruby_utils/require_sub'
::EacRubyUtils.require_sub(__FILE__)
