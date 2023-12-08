# frozen_string_literal: true

module RedminePluginsHelper
  class Migration
    module Code
      common_concern

      module ClassMethods
        # @return [Enumerable<RedminePluginsHelper::Migration>]
        def from_code
          from_core_code + from_plugins_code
        end

        # @return [Enumerable<RedminePluginsHelper::Migration>]
        def from_core_code
          ::Rails.application.paths['db/migrate'].flat_map do |path|
            from_path_code(path)
          end
        end

        # @return [Enumerable<RedminePluginsHelper::Migration>]
        def from_path_code(path)
          ::Dir["#{path}/*.rb"].map { |p| File.basename(p).match(/0*(\d+)\_/)[1].to_i }.sort
            .map { |version| new(PLUGIN_ID_CORE_VALUE, version) }
        end

        # @return [Enumerable<RedminePluginsHelper::Migration>]
        def from_plugins_code
          ::Redmine::Plugin.registered_plugins.values.flat_map do |plugin|
            plugin.migrations.map { |version| new(plugin.id, version) }
          end
        end
      end
    end
  end
end
