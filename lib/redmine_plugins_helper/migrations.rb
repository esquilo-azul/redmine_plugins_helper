module RedminePluginsHelper
  class Migrations
    class << self
      def local_versions
        r = {}
        Redmine::Plugin.registered_plugins.values.each do |p|
          p.migrations.each do |ts|
            r[p.id] ||= []
            r[p.id] << ts
          end
        end
        r
      end

      def db_versions
        r = {}
        db_all_versions.each do |v|
          pv = parse_plugin_version(v)
          next unless pv
          r[pv[:plugin]] ||= []
          r[pv[:plugin]] << pv[:timestamp]
        end
        r
      end

      private

      def parse_plugin_version(v)
        m = v.match(/^(\d+)\-(\S+)$/)
        return nil unless m
        { plugin: m[2].to_sym, timestamp: m[1].to_i }
      end

      def db_all_versions
        ::ActiveRecord::Base.connection.select_values(
          "SELECT version FROM #{ActiveRecord::Migrator.schema_migrations_table_name}"
        )
      end
    end
  end
end
