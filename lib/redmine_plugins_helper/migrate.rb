# frozen_string_literal: true

module RedminePluginsHelper
  class Migrate
    attr_reader :plugin_name, :migration_version

    def initialize(plugin_name, migration_version)
      @plugin_name = plugin_name
      @migration_version = migration_version
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
      versions_sorted.each do |v|
        migrate_plugin_version(v)
      end
    end

    def run_version
      ::Redmine::Plugin.migrate(plugin_name, migration_version)
    end

    def migrate_plugin_version(v)
      return if migrated?(v)

      ::Redmine::Plugin.registered_plugins[v[:plugin]].migrate(v[:timestamp])
    end

    def versions_sorted
      versions.sort_by { |e| [e[:timestamp]] }
    end

    def versions
      r = []
      ::RedminePluginsHelper::Migrations.local_versions.each do |plugin, ts|
        ts.each { |t| r << { plugin: plugin, timestamp: t } }
      end
      r
    end

    def migrated?(v)
      return false unless db_versions.key?(v[:plugin])
      db_versions[v[:plugin]].include?(v[:timestamp])
    end

    def db_versions
      @db_versions ||= ::RedminePluginsHelper::Migrations.db_versions
    end
  end
end
