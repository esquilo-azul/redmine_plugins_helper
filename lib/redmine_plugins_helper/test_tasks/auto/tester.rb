# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'redmine_plugins_helper/test_tasks/base'
require 'redmine_plugins_helper/test_tasks/minitest'
require 'redmine_plugins_helper/test_tasks/rspec'

module RedminePluginsHelper
  module TestTasks
    class Auto < ::RedminePluginsHelper::TestTasks::Base
      class Tester
        enable_simple_cache
        common_constructor :owner, :name, :tests_pattern
        delegate :register, to: :sub

        # @return [Boolean]
        def available?
          owner.plugin_root.glob(tests_pattern).any?
        end

        private

        # @!method sub
        #   @return [RedminePluginsHelper::TestTasks::Base]
        def sub_uncached
          ::RedminePluginsHelper::TestTasks.const_get(name.to_s.camelize).new(owner.plugin_id, name)
        end
      end
    end
  end
end
