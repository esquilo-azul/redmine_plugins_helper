# frozen_string_literal: true

module RedminePluginsHelper
  class Migrations
    class << self
      def local_versions
        r = {}
        ::RedminePluginsHelper::Migration.from_code.select(&:plugin?).each do |migration|
          r[migration.plugin_id] ||= []
          r[migration.plugin_id] << migration.version
        end
        r
      end

      def db_versions
        r = {}
        ::RedminePluginsHelper::Migration.from_database.select(&:plugin?).each do |migration|
          r[migration.plugin_id] ||= []
          r[migration.plugin_id] << migration.version
        end
        r
      end
    end
  end
end
