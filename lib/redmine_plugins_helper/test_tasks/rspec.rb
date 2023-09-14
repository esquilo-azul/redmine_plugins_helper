# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'rspec/core/rake_task'
require 'shellwords'

module RedminePluginsHelper
  module TestTasks
    class Rspec
      DEFAULT_TASK_NAME_LAST_PART = 'rspec'

      class << self
        def register(plugin_id, task_name_last_part = DEFAULT_TASK_NAME_LAST_PART)
          new(plugin_id, task_name_last_part).register
        end
      end

      common_constructor :plugin_id, :task_name_last_part

      def register
        ::RSpec::Core::RakeTask.new(task_full_name) do |t|
          t.rspec_opts = ::Shellwords.join(rspec_opts)
        end
        Rake::Task[task_full_name].enhance ['db:test:prepare']
      end

      def task_full_name
        "#{plugin_id}:#{task_name_last_part}"
      end

      def rspec_opts
        ['--pattern', "plugins/#{plugin_id}/spec/**/*_spec.rb",
         '--default-path', 'plugins/redmine_plugins_helper/spec',
         '--require', 'spec_helper']
      end
    end
  end
end
