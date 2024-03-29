# frozen_string_literal: true

require_dependency 'redmine_plugins_helper/available'

module RedminePluginsHelper
  class Settings
    class << self
      def default(plugin, default)
        return unless ::RedminePluginsHelper::Available.settings?

        p = plugin_current_setting_value(plugin)
        default.each do |k, v|
          p[k.to_s] = v unless p.key?(k)
        end
        ::Setting.send("plugin_#{plugin}=", p)
      end

      private

      def plugin_current_setting_value(plugin)
        p = ::Setting.send("plugin_#{plugin}")
        p = {} unless p.is_a?(::Hash)
        p.with_indifferent_access
      end
    end
  end
end
