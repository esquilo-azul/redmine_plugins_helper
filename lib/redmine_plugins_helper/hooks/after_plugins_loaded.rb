# frozen_string_literal: true

module RedminePluginsHelper
  module Hooks
    class AfterPluginsLoaded < Redmine::Hook::Listener
      def after_plugins_loaded(_context = {})
        require 'redmine_plugins_helper/patches'
        Redmine::Plugin.sorted_by_dependencies.each(&:add_assets_paths)
        Redmine::Plugin.sorted_by_dependencies.each(&:load_initializers)
        RedminePluginsHelper::PluginsAutoloadAssets.instance.generate
      end
    end
  end
end
