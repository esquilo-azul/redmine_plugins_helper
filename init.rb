# coding: utf-8

require 'redmine'
require 'redmine_plugins_helper/patches/test_case_patch'

Redmine::Plugin.register :redmine_plugins_helper do
  name 'Redmine Plugins\' Helper'
  author 'Eduardo Henrique Bogoni'
  description 'Helper for Redmine plugins'
  version '0.1.0'
end
