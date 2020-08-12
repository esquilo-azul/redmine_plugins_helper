# frozen_string_literal: true

require 'active_support'

module RedminePluginsHelper
  module Patches
    module TestCasePatch
      extend ActiveSupport::Concern

      included do
        extend ClassMethods
        include InstanceMethods
        setup { the_test_config.before_each }
        teardown { the_test_config.after_each }
      end

      module ClassMethods
        def plugin_fixtures(plugin_name, *files)
          fixtures_dir = File.expand_path(
            'test/fixtures',
            ::Redmine::Plugin.registered_plugins[plugin_name].directory
          )
          ActiveRecord::FixtureSet.create_fixtures(fixtures_dir, files)
          fixtures(*files)
        end
      end

      module InstanceMethods
        def the_test_config
          @the_test_config ||= ::RedminePluginsHelper::TestConfig.new
        end
      end
    end
  end
end

unless ActiveSupport::TestCase.included_modules.include?(
  RedminePluginsHelper::Patches::TestCasePatch
)
  ActiveSupport::TestCase.include RedminePluginsHelper::Patches::TestCasePatch
end
