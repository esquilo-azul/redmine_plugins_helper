module RedminePluginsHelper
  class Settings
    class << self
      def default(plugin, default)
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
