namespace :redmine do
  namespace :plugins do
    namespace :migrate do
      desc 'Fix migrations moved from a plugin to another'
      task fix: :environment do
        RedminePluginsHelper::FixMigrations.new
      end
    end
  end
end
