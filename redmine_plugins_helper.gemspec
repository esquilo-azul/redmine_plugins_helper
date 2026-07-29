# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'redmine_plugins_helper/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'redmine_plugins_helper'
  s.version     = RedminePluginsHelper::VERSION
  s.authors     = [RedminePluginsHelper::VERSION]
  s.summary     = RedminePluginsHelper::SUMMARY

  s.files = Dir['{app,config,lib}/**/*', 'init.rb']
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'eac_rails_gem_support', '~> 0.13', '>= 0.13.2'
  s.add_dependency 'eac_ruby_utils', '~> 0.131', '>= 0.131.4'
  s.add_dependency 'launchy', '~> 2.5', '>= 2.5.2'
  s.add_dependency 'sassc-rails', '~> 2.1', '>= 2.1.2'
end
