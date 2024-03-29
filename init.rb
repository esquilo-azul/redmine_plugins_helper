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
  require_dependency 'redmine_plugins_helper/patches'
  Redmine::Plugin.all.sort.each(&:add_assets_paths)
  Redmine::Plugin.all.sort.each(&:load_initializers)
end
