# frozen_string_literal: true

module RedminePluginsHelper
  class Migration
    module Database
      common_concern

      DATABASE_CORE_VERSION_PARSER = /^(\d+)$/.to_parser { |m| [PLUGIN_ID_CORE_VALUE, m[1]] }
      DATABASE_PLUGIN_VERSION_PARSER = /^(\d+)-(\S+)$/.to_parser { |m| [m[2], m[1]] }
      DATABASE_VERSION_PARSERS = [DATABASE_PLUGIN_VERSION_PARSER, DATABASE_CORE_VERSION_PARSER]
                                   .freeze

      module ClassMethods
        # @return [Enumerable<RedminePluginsHelper::Migration>]
        def from_database
          schema_migration = ::ActiveRecord::Base.connection_pool.schema_migration
          schema_migration.create_table
          schema_migration.versions.map do |version|
            from_database_version(version)
          end
        end

        # @return [RedminePluginsHelper::Migration]
        def from_database_version(version)
          DATABASE_VERSION_PARSERS
            .lazy
            .map { |parser| parser.parse(version).if_present { |args| new(*args) } }
            .find(&:present?) || raise("None parser parsed \"#{version}\"")
        end
      end
    end
  end
end
