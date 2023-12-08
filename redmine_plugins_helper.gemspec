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

  s.add_dependency 'bigdecimal', '~> 1.4', '>= 1.4.4'
  s.add_dependency 'eac_ruby_utils', '~> 0.120'
  s.add_dependency 'launchy', '~> 2.5', '>= 2.5.2'
  s.add_dependency 'sass-rails', '~> 5.0'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.5.1'
end
