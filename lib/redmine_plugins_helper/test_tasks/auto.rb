# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'redmine_plugins_helper/test_tasks/base'
require 'rake/task'

module RedminePluginsHelper
  module TestTasks
    class Auto < ::RedminePluginsHelper::TestTasks::Base
      TESTERS = {
        minitest: 'test/**/*_test.rb',
        rspec: 'spec/**/*_spec.rb'
      }

      enable_simple_cache

      # @return [void]
      def register
        return unless available_testers.any?(&:available?)

        available_testers.each(&:register)

        ::Rake::Task.new(task_full_name)
        ::Rake::Task[task_full_name].enhance available_testers.map(&:name)
      end

      private

      # @return [Array<String>]
      def available_testers_uncached
        TESTERS.map do |name, tests_pattern|
          ::RedminePluginsHelper::TestTasks::Auto::Tester.new(self, name, tests_pattern)
        end.select(&:available?)
      end
    end
  end
end
