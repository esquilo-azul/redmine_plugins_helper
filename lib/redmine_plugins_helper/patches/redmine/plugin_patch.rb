module RedminePluginsHelper
  module Patches
    module Redmine
      module PluginPatch
        extend ActiveSupport::Concern

        included do
          extend ClassMethods
          include InstanceMethods
        end

        ASSETS_SUBDIRS = %w[stylesheets javascripts images].freeze

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

          ASSETS_SUBDIRS.each do |assert_subdir|
            class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
            def #{assert_subdir}_directory
              ::File.join(directory, 'app', 'assets', '#{assert_subdir}')
            end
            RUBY_EVAL
          end

          def add_assets_paths
            ASSETS_SUBDIRS.each do |assert_subdir|
              assets_directory = send("#{assert_subdir}_directory")
              next unless ::File.directory?(assets_directory)

              Rails.application.config.assets.paths << assets_directory
            end
          end

          def main_javascript_asset_path
            find_asset(javascripts_directory, %w[js coffee js.coffee])
          end

          def main_stylesheet_asset_path
            find_asset(stylesheets_directory, %w[css scss])
          end

          private

          def initializers_directory
            File.join(directory, 'config', 'initializers')
          end

          def find_asset(assets_directory, extensions)
            extensions.each do |extension|
              ['', '.erb'].each do |erb_extension|
                path = ::File.join(assets_directory, "#{id}.#{extension}#{erb_extension}")
                return id if ::File.exist?(path)
              end
            end
            nil
          end
        end
      end
    end
  end
end

patch = ::RedminePluginsHelper::Patches::Redmine::PluginPatch
target = ::Redmine::Plugin
target.send(:include, patch) unless target.include?(patch)
