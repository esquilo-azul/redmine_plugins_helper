module RedminePluginsHelper
  module Patches
    module Redmine
      module PluginPatch
        extend ActiveSupport::Concern

        included do
          extend ClassMethods
          include InstanceMethods
        end

        module ClassMethods
          def post_register(plugin_name, &block)
            plugin = registered_plugins[plugin_name]
            raise "Plugin not registered: #{plugin_name}" unless plugin
            plugin.instance_eval(&block)
          end
        end

        module InstanceMethods
          def load_initializers
            Dir["#{initializers_directory}/*.rb"].each { |f| require f }
          end

          private

          def initializers_directory
            File.join(directory, 'config', 'initializers')
          end
        end
      end
    end
  end
end

patch = ::RedminePluginsHelper::Patches::Redmine::PluginPatch
target = ::Redmine::Plugin
target.send(:include, patch) unless target.include?(patch)
