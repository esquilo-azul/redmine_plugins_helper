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
      fix_plugin_version(dbv, lv.first[:plugin])
    end

    def fix_plugin_version(dbv, target_plugin)
      target_version = plugin_version(target_plugin, dbv[:timestamp])
      if database_version?(target_version)
        remove_plugin_version(dbv[:version])
      else
        move_plugin_version(dbv[:version], target_version)
      end
    end

    def database_version?(version)
      r = ::ActiveRecord::Base.connection.execute(<<EOS.strip_heredoc)
        select exists(
          select 1
          from #{ActiveRecord::Migrator.schema_migrations_table_name}
          where version=#{ActiveRecord::Base.sanitize(version)}
        )
EOS
      r.getvalue(0, 0) == 't'
    end

    def remove_plugin_version(source_version)
      Rails.logger.info("Removing #{source_version}")
      ::ActiveRecord::Base.connection.execute(<<EOS.strip_heredoc)
        delete from #{ActiveRecord::Migrator.schema_migrations_table_name}
        where version=#{ActiveRecord::Base.sanitize(source_version)}
EOS
    end

    def move_plugin_version(source_version, target_version)
      Rails.logger.info("Moving #{source_version} to plugin \"#{target_version}\"")
      ::ActiveRecord::Base.connection.execute(<<EOS.strip_heredoc)
        update #{ActiveRecord::Migrator.schema_migrations_table_name}
        set version=#{ActiveRecord::Base.sanitize(target_version)}
        where version=#{ActiveRecord::Base.sanitize(source_version)}
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
        ::RedminePluginsHelper::Migrations.db_all_versions.each do |v|
          pv = parse_plugin_version(v)
          next unless pv
          r << pv
        end
        r
      end
    end

    def parse_plugin_version(v)
      h = ::RedminePluginsHelper::Migrations.parse_plugin_version(v)
      h[:version] = v if h.is_a?(Hash)
      h
    end

    def plugin_version(plugin_id, timestamp)
      "#{timestamp}-#{plugin_id}"
    end
  end
end
