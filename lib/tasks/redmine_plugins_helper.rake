Rake::Task['redmine:plugins:migrate'].clear

namespace :redmine do
  desc 'Run migrations of core Redmine and installed plugins.'
  task migrate: ['db:migrate', 'redmine:plugins:migrate:fix', 'redmine:plugins:migrate'] do
  end

  namespace :version do
    desc 'Shows Redmine\'s version.'
    task show: :environment do
      puts ::Redmine::VERSION::STRING
    end
  end

  task version: 'version:show'

  namespace :plugins do
    desc 'Migrates installed plugins.'
    task migrate: :environment do
      RedminePluginsHelper::Migrate.new
      Rake::Task['db:schema:dump'].invoke
    end

    namespace :migrate do
      desc 'Fix migrations moved from a plugin to another'
      task fix: :environment do
        RedminePluginsHelper::FixMigrations.new
      end

      desc 'Show migrations status of all plugins'
      task status: :environment do
        RedminePluginsHelper::StatusMigrations.new
      end
    end
  end
end
