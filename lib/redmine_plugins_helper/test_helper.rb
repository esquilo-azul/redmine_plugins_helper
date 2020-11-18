# frozen_string_literal: true

module RedminePluginsHelper
  module TestHelper
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
