# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'redmine_plugins_helper/test_tasks/base'
require 'rspec/core/rake_task'

module RedminePluginsHelper
  module TestTasks
    class Rspec < ::RedminePluginsHelper::TestTasks::Base
      def register
        ::RSpec::Core::RakeTask.new(task_full_name) do |t|
          t.rspec_opts = ::Shellwords.join(rspec_opts)
        end
        ::Rake::Task[task_full_name].enhance [prepare_task_name]
      end

      def rspec_opts
        ['--pattern', plugin_root.join('spec/**/*_spec.rb'),
         '--default-path', 'plugins/redmine_plugins_helper/spec',
         '--require', 'spec_helper']
      end
    end
  end
end
