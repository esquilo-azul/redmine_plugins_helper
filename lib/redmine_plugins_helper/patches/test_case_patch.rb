require 'active_support'

module RedminePluginsHelper
  module Patches
    module TestCasePatch
      extend ActiveSupport::Concern

      included do
        extend ClassMethods
        include InstanceMethods
        setup { mailer_setup }
        teardown { mailer_teadown }
      end

      module ClassMethods
        def plugin_fixtures(plugin_name, *files)
          fixtures_dir = File.expand_path(
            'test/fixtures',
            ::Redmine::Plugin.registered_plugins[plugin_name].directory
          )
          ActiveRecord::FixtureSet.create_fixtures(fixtures_dir, files)
          fixtures(*files)
        end
      end

      module InstanceMethods
        def mailer_setup
          unless @mailer_perform_deliveries_changed
            @mailer_perform_deliveries_changed = true
            @mailer_perform_deliveries_was_enabled = ::ActionMailer::Base.perform_deliveries
          end
          ::ActionMailer::Base.perform_deliveries = false
        end

        def mailer_teadown
          return unless @mailer_perform_deliveries_changed

          ::ActionMailer::Base.perform_deliveries = @mailer_perform_deliveries_was_enabled
          @mailer_perform_deliveries_changed = false
        end
      end
    end
  end
end

unless ActiveSupport::TestCase.included_modules.include?(
  RedminePluginsHelper::Patches::TestCasePatch
)
  ActiveSupport::TestCase.send(:include, RedminePluginsHelper::Patches::TestCasePatch)
end
