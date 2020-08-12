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

    def migrate_plugin_version(version)
      return if migrated?(version)

      ::Redmine::Plugin.registered_plugins[version[:plugin]].migrate(version[:timestamp])
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

    def migrated?(version)
      return false unless db_versions.key?(version[:plugin])

      db_versions[version[:plugin]].include?(version[:timestamp])
    end

    def db_versions
      @db_versions ||= ::RedminePluginsHelper::Migrations.db_versions
    end
  end
end
