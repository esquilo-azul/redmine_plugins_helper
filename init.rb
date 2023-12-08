# frozen_string_literal: true

require 'redmine'
require 'redmine_plugins_helper/version'
require 'redmine_plugins_helper/patches/test_case_patch'

Redmine::Plugin.register :redmine_plugins_helper do
  name 'Redmine Plugins\' Helper'
  author RedminePluginsHelper::AUTHOR
  description RedminePluginsHelper::SUMMARY
  version RedminePluginsHelper::VERSION
end

Rails.configuration.to_prepare do
  require_dependency 'redmine_plugins_helper/patches/redmine/plugin_patch'
  require_dependency 'redmine_plugins_helper/patches/redmine/plugin_migration_context'
  Redmine::Plugin.all.each(&:add_assets_paths) # rubocop:disable Rails/FindEach
  Redmine::Plugin.all.each(&:load_initializers) # rubocop:disable Rails/FindEach
end
