# frozen_string_literal: true

require 'active_support'

module RedminePluginsHelper
  module Patches
    module TestCasePatch
      extend ActiveSupport::Concern

      included do
        extend ::RedminePluginsHelper::TestHelper
        include InstanceMethods
        setup { the_test_config.before_each }
        teardown { the_test_config.after_each }
      end

      module InstanceMethods
        def the_test_config
          @the_test_config ||= ::RedminePluginsHelper::TestConfig.new
        end
      end
    end
  end
end

unless ActiveSupport::TestCase.included_modules.include?(
  RedminePluginsHelper::Patches::TestCasePatch
)
  ActiveSupport.on_load(:active_support_test_case) do
    include RedminePluginsHelper::Patches::TestCasePatch
  end
end
