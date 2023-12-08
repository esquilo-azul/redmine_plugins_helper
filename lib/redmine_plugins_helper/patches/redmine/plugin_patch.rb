# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module RedminePluginsHelper
  module Patches
    module Redmine
      module PluginPatch
        extend ActiveSupport::Concern

        included do
          extend ClassMethods
          include ::RedminePluginsHelper::Patches::Redmine::PluginPatch::Assets
          prepend ::RedminePluginsHelper::Patches::Redmine::PluginPatch::Dependencies
          include ::RedminePluginsHelper::Patches::Redmine::PluginPatch::Initializers
        end

        module ClassMethods
          def by_path(path)
            plugin_id_from_path(path).if_present do |v|
              registered_plugins[v]
            end
          end

          def plugin_id_from_path(path)
            path = path.to_pathname.expand_path
            return nil unless path.to_path.start_with?(::Rails.root.to_path)

            parts = path.relative_path_from(::Rails.root).each_filename.to_a
            return nil unless parts.first == 'plugins' && parts.count >= 2

            parts[1].to_sym
          end

          def post_register(plugin_name, &block)
            plugin = registered_plugins[plugin_name]
            raise "Plugin not registered: #{plugin_name}" unless plugin

            plugin.instance_eval(&block)
          end
        end

        require_sub __FILE__
      end
    end
  end
end

patch = RedminePluginsHelper::Patches::Redmine::PluginPatch
target = Redmine::Plugin
target.send(:include, patch) unless target.include?(patch)
