# frozen_string_literal: true

module RedminePluginsHelper
  class Migration
    require_sub __FILE__, include_modules: true

    PLUGIN_ID_CORE_VALUE = :_core_

    common_constructor :plugin_id, :version do
      self.plugin_id = plugin_id.to_sym
      self.version = version.to_i
    end
    compare_by :version, :plugin_id

    # @return [void]
    def apply
      return if applied?

      nyi unless plugin?

      ::Redmine::Plugin::Migrator.current_plugin = plugin
      ::Redmine::Plugin::MigrationContext.new(plugin.migration_directory).up do |m|
        m.version == version
      end
    end

    # @return [Boolean]
    def applied?
      ::ActiveRecord::SchemaMigration.create_table
      ::ActiveRecord::SchemaMigration.where(version: database_version).any?
    end

    # @return [String]
    def database_version
      core? ? version.to_s : "#{version}-#{plugin_id}"
    end

    # @return [Boolean]
    def core?
      plugin_id == PLUGIN_ID_CORE_VALUE
    end

    # @return [Redmine::Plugin]
    def plugin
      plugin? ? ::Redmine::Plugin.find(plugin_id) : nil
    end

    # @return [Boolean]
    def plugin?
      !core?
    end
  end
end
