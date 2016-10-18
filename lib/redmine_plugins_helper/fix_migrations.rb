module RedminePluginsHelper
  class FixMigrations
    def initialize
      run
    end

    private

    def run
      database_plugins_versions.each do |dbv|
        check_database_version(dbv)
      end
      Rails.logger.info("Database versions checked: #{database_plugins_versions.count}")
      Rails.logger.info("Local versions found: #{local_versions.count}")
    end

    def check_database_version(dbv)
      lv = local_version(dbv[:timestamp])
      return unless lv && lv.count == 1 && dbv[:plugin] != lv.first[:plugin]
      move_plugin_version(dbv, lv.first[:plugin])
    end

    def move_plugin_version(dbv, target_plugin)
      target_version = plugin_version(target_plugin, dbv[:timestamp])
      Rails.logger.debug("Moving #{dbv[:version]} to plugin \"#{target_version}\"")
      ::ActiveRecord::Base.connection.execute(<<EOS)
update #{ActiveRecord::Migrator.schema_migrations_table_name}
set version=#{ActiveRecord::Base.sanitize(target_version)}
where version=#{ActiveRecord::Base.sanitize(dbv[:version])}
EOS
    end

    def local_version(timestamp)
      return [] unless local_versions.key?(timestamp)
      local_versions[timestamp]
    end

    def local_versions
      @local_versions = begin
        r = {}
        Redmine::Plugin.registered_plugins.values.each do |p|
          p.migrations.each do |m|
            r[m] ||= []
            r[m] << { plugin: p.id, timestamp: m, version: plugin_version(p.id, m) }
          end
        end
        r
      end
    end

    def database_plugins_versions
      @database_plugins_versions = begin
        r = []
        database_all_versions.each do |v|
          pv = parse_plugin_version(v)
          next unless pv
          r << pv
        end
        r
      end
    end

    def parse_plugin_version(v)
      m = v.match(/^(\d+)\-(\S+)$/)
      return nil unless m
      { plugin: m[2].to_sym, timestamp: m[1].to_i, version: v }
    end

    def plugin_version(plugin_id, timestamp)
      "#{timestamp}-#{plugin_id}"
    end

    def database_all_versions
      ::ActiveRecord::Base.connection.select_values(
        "SELECT version FROM #{ActiveRecord::Migrator.schema_migrations_table_name}"
      )
    end
  end
end
