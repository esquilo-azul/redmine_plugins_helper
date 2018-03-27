require 'active_support'

module RedminePluginsHelper
  module Patches
    module TestCasePatch
      extend ActiveSupport::Concern

      included do
        extend ClassMethods
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
    end
  end
end

unless ActiveSupport::TestCase.included_modules.include?(
  RedminePluginsHelper::Patches::TestCasePatch
)
  ActiveSupport::TestCase.send(:include, RedminePluginsHelper::Patches::TestCasePatch)
end
