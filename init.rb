# frozen_string_literal: true

require 'redmine'
require 'redmine_plugins_helper/version'
require 'redmine_plugins_helper/patches/test_case_patch'
require 'redmine_plugins_helper/hooks/after_plugins_loaded'

Redmine::Plugin.register :redmine_plugins_helper do
  name 'Redmine Plugins\' Helper'
  author RedminePluginsHelper::AUTHOR
  description RedminePluginsHelper::SUMMARY
  version RedminePluginsHelper::VERSION
end
