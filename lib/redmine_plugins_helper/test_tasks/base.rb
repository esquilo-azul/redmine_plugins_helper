# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module RedminePluginsHelper
  module TestTasks
    class Base
      acts_as_abstract :register
      DEFAULT_TASK_NAME_LAST_PART = 'test'
      PREPARE_TASK_NAME = 'db:test:prepare'

      class << self
        def register(plugin_id, task_name_last_part = DEFAULT_TASK_NAME_LAST_PART)
          new(plugin_id, task_name_last_part).register
        end
      end

      common_constructor :plugin_id, :task_name_last_part

      # @return [Pathname]
      def plugin_root
        ::Rails.root.join('plugins', plugin_id.to_s)
      end

      # @return [String]
      def prepare_task_name
        PREPARE_TASK_NAME
      end

      # @return [String]
      def task_full_name
        "#{plugin_id}:#{task_name_last_part}"
      end
    end
  end
end
