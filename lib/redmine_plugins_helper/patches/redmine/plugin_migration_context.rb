# frozen_string_literal: true

require 'redmine/plugin'

module RedminePluginsHelper
  module Patches
    module Redmine
      module PluginMigrationContext
        extend ActiveSupport::Concern

        def get_all_versions # rubocop:disable Naming/AccessorMethodName
          plugin.present? ? plugin.migrations : super
        end

        private

        def plugin
          @plugin ||= ::Redmine::Plugin.registered_plugins.values.find do |plugin|
            ::File.join(plugin.directory, 'db', 'migrate') == migrations_paths
          end
        end
      end
    end
  end
end

if Redmine::Plugin.const_defined?(:MigrationContext)
  Redmine::Plugin::MigrationContext.prepend(
    RedminePluginsHelper::Patches::Redmine::PluginMigrationContext
  )
end
