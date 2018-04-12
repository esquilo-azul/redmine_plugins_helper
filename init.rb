# coding: utf-8

require 'redmine'
require 'redmine_plugins_helper/patches/test_case_patch'

Redmine::Plugin.register :redmine_plugins_helper do
  name 'Redmine Plugins\' Helper'
  author 'Eduardo Henrique Bogoni'
  description 'Helper for Redmine plugins'
  version '0.2.0'
end

Rails.configuration.to_prepare do
  require_dependency 'redmine_plugins_helper/patches/redmine/plugin_patch'
  ::Redmine::Plugin.registered_plugins.values.each(&:load_initializers)
end
