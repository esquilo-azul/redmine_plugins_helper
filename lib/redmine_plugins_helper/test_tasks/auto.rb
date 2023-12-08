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
      }.freeze

      enable_simple_cache

      # @return [void]
      def register
        return unless available_testers.any?(&:available?)

        available_testers.each(&:register)
        ::Rake::Task.define_task(task_full_name => available_testers.map(&:name))
      end

      private

      # @return [Array<String>]
      def available_testers_uncached
        TESTERS.map do |name, tests_pattern|
          ::RedminePluginsHelper::TestTasks::Auto::Tester.new(self, name, tests_pattern)
        end.select(&:available?)
      end

      require_sub __FILE__
    end
  end
end
