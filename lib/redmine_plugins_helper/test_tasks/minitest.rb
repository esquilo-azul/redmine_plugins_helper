# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'redmine_plugins_helper/test_tasks/base'
require 'rake/testtask'

module RedminePluginsHelper
  module TestTasks
    class Minitest < ::RedminePluginsHelper::TestTasks::Base
      def register
        ::Rake::TestTask.new(task_full_name => 'db:test:prepare') do |t|
          t.description = "Run plugin #{plugin_id}\'s tests."
          t.libs << 'test'
          t.test_files = ::FileList["#{plugin_root}/test/**/*_test.rb"]
          t.verbose = false
          t.warning = false
        end
      end
    end
  end
end
