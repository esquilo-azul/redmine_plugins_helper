# frozen_string_literal: true

module RedminePluginsHelper
  class FixMigrations
    def perform
      database_plugins_versions.each do |dbv|
        check_database_version(dbv)
      end
      Rails.logger.info("Database versions checked: #{database_plugins_versions.count}")
      Rails.logger.info("Local versions found: #{local_versions.count}")
    end

    private

    def check_database_version(dbv)
      lv = local_version(dbv[:timestamp])
      return unless lv && lv.one? && dbv[:plugin] != lv.first[:plugin]

      fix_plugin_version(dbv, lv.first[:plugin])
    end

    def fix_plugin_version(dbv, target_plugin)
      target_version = plugin_version(target_plugin, dbv[:timestamp])
      if database_version?(target_version)
        remove_plugin_version(dbv[:version])
      else
        move_plugin_version(dbv[:version], target_version)
      end
    end

    def database_version?(version)
      schema_migration.versions.include?(version)
    end

    def remove_plugin_version(source_version)
      Rails.logger.info("Removing #{source_version}")
      schema_migration.delete_version(source_version)
    end

    def move_plugin_version(source_version, target_version)
      Rails.logger.info("Moving #{source_version} to plugin \"#{target_version}\"")
      schema_migration.delete_version(source_version)
      schema_migration.create_version(target_version)
    end

    def schema_migration
      @schema_migration ||= ::ActiveRecord::Base.connection_pool.schema_migration
    end

    def local_version(timestamp)
      return [] unless local_versions.key?(timestamp)

      local_versions[timestamp]
    end

    def local_versions
      @local_versions ||= begin
        r = {}
        Redmine::Plugin.registered_plugins.each_value do |p|
          p.migrations.each do |m|
            r[m] ||= []
            r[m] << { plugin: p.id, timestamp: m, version: plugin_version(p.id, m) }
          end
        end
        r
      end
    end

    def database_plugins_versions
      @database_plugins_versions ||= ::RedminePluginsHelper::Migration
                                       .from_database.select(&:plugin?).map do |m|
        { plugin: m.plugin_id, timestamp: m.version, version: m.database_version }
      end
    end

    def plugin_version(plugin_id, timestamp)
      "#{timestamp}-#{plugin_id}"
    end
  end
end
