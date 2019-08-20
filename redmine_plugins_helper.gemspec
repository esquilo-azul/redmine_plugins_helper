# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'redmine_plugins_helper/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'redmine_plugins_helper'
  s.version     = ::RedminePluginsHelper::VERSION
  s.authors     = [::RedminePluginsHelper::VERSION]
  s.summary     = ::RedminePluginsHelper::SUMMARY

  s.files = Dir['{app,config,lib}/**/*', 'init.rb']

  s.add_dependency 'sass-rails', '~> 5.0'
end
