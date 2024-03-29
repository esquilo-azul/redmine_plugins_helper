# frozen_string_literal: true

module RedminePluginsHelper
  module Patches
    require_dependency 'redmine_plugins_helper/patches/redmine/plugin'
    require_dependency 'redmine_plugins_helper/patches/redmine/plugin_migration_context'
  end
end
