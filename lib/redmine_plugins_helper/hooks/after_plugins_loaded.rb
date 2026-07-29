# frozen_string_literal: true

module RedminePluginsHelper
  module Hooks
    class AfterPluginsLoaded < Redmine::Hook::Listener
      def after_plugins_loaded(_context = {})
        require 'redmine_plugins_helper/patches'
        Redmine::Plugin.all.sort.each(&:add_assets_paths)
        Redmine::Plugin.all.sort.each(&:load_initializers)
        Rails.application.config.after_initialize do
          RedminePluginsHelper::PluginsAutoloadAssets.instance.generate
        end
      end
    end
  end
end
