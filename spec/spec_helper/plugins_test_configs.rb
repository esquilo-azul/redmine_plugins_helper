# frozen_string_literal: true

def test_config_class(plugin_name)
  ::Object.const_get(plugin_name.to_s.camelcase).const_get('TestConfig')
rescue ::NameError
  nil
end

def test_config_instance(plugin_name)
  klass = test_config_class(plugin_name)
  klass ? klass.new : nil
end

::Redmine::Plugin.registered_plugins.each_key do |plugin|
  instance = test_config_instance(plugin)
  next unless instance

  RSpec.configure do |config|
    %i[before after].each do |prefix|
      %i[each all].each do |suffix|
        method = "#{prefix}_#{suffix}".to_sym
        config.send(prefix, suffix) { instance.send(method) } if instance.respond_to?(method)
      end
    end
  end
end
