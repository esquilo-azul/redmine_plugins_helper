# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'redmine_plugins_helper/test_tasks/base'
require 'rake/testtask'

module RedminePluginsHelper
  module TestTasks
    class Auto < ::RedminePluginsHelper::TestTasks::Base
      class Tester
        common_constructor :owner, :name, :tests_pattern

      end
    end
  end
end
