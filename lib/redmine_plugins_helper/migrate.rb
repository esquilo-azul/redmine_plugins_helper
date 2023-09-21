# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module RedminePluginsHelper
  class Migrate
    common_constructor :plugin_name, :migration_version do
      run
    end

    private

    def run
      if plugin_name.present?
        run_version
      else
        run_all
      end
    end

    def run_all
      versions_sorted.each(&:apply)
    end

    def run_version
      ::Redmine::Plugin.migrate(plugin_name, migration_version)
    end

    # @return [Enumerable<RedminePluginsHelper::Migration>]
    def versions_sorted
      versions.sort
    end

    # @return [Enumerable<RedminePluginsHelper::Migration>]
    def versions
      ::RedminePluginsHelper::Migration.from_code.select(&:plugin?)
    end
  end
end
