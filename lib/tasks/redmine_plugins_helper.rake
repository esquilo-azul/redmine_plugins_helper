Rake::Task['redmine:plugins:migrate'].clear

namespace :redmine do
  desc 'Migrates core app and installed plugins.'
  task migrate: ['db:migrate', 'redmine:plugins:migrate:fix', 'redmine:plugins:migrate'] do
  end

  namespace :plugins do
    desc 'Migrates installed plugins.'
    task migrate: :environment do
      RedminePluginsHelper::Migrate.new
    end

    namespace :migrate do
      desc 'Fix migrations moved from a plugin to another'
      task fix: :environment do
        RedminePluginsHelper::FixMigrations.new
      end

      desc 'Fix migrations moved from a plugin to another'
      task status: :environment do
        RedminePluginsHelper::StatusMigrations.new
      end
    end
  end
end
