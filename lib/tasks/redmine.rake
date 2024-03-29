# frozen_string_literal: true

Rake::Task['redmine:plugins:migrate'].clear

namespace :redmine do # rubocop:disable Metrics/BlockLength
  desc 'Run migrations of core Redmine and installed plugins.'
  task migrate: ['db:migrate', 'redmine:plugins:migrate:fix', 'redmine:plugins:migrate']

  namespace :version do
    desc 'Shows Redmine\'s version.'
    task show: :environment do
      puts Redmine::VERSION::STRING
    end
  end

  task version: 'version:show'

  namespace :plugins do # rubocop:disable Metrics/BlockLength
    desc 'Migrates installed plugins.'
    task migrate: :environment do
      name = ENV.fetch('NAME', nil)
      version = nil
      version_string = ENV.fetch('VERSION', nil)
      if version_string
        if version_string =~ /^\d+$/
          version = version_string.to_i
          abort 'The VERSION argument requires a plugin NAME.' if name.nil?
        else
          abort "Invalid VERSION #{version_string} given."
        end
      end

      begin
        RedminePluginsHelper::Migrate.new(name, version)
        Rake::Task['db:schema:dump'].invoke
      rescue Redmine::PluginNotFound
        abort "Plugin #{name} was not found."
      end
    end

    namespace :migrate do
      desc 'Fix migrations moved from a plugin to another'
      task fix: :environment do
        RedminePluginsHelper::FixMigrations.new.perform
      end

      desc 'Show migrations status of all plugins'
      task status: :environment do
        RedminePluginsHelper::StatusMigrations.new
      end
    end
  end
end
