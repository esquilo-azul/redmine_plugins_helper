module RedminePluginsHelper
  class StatusMigrations
    def initialize
      run
    end

    private

    def run
      local_versions.each do |plugin, timestamps|
        timestamps.each do |timestamp|
          m = migrated_version?(plugin, timestamp) ? 'up' : 'down'
          puts "#{m}\t#{plugin}\t#{timestamp}"
        end
      end
    end

    def migrated_version?(plugin, timestamp)
      db_versions.key?(plugin) &&
        db_versions[plugin].include?(timestamp)
    end

    def local_versions
      @local_versions ||= ::RedminePluginsHelper::Migrations.local_versions
    end

    def db_versions
      @db_versions ||= ::RedminePluginsHelper::Migrations.db_versions
    end
  end
end
