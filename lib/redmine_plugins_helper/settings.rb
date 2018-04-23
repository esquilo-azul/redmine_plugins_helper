require_dependency 'redmine_plugins_helper'

module RedminePluginsHelper
  class Settings
    class << self
      def default(plugin, default)
        return unless ::RedminePluginsHelper.settings_table_exist?
        p = ::Setting.send("plugin_#{plugin}")
        p ||= {}
        default.each do |k, v|
          p[k] = v unless p.key?(k)
        end
        ::Setting.send("plugin_#{plugin}=", p)
      end
    end
  end
end
