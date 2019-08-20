require 'sass-rails'

module RedminePluginsHelper
  class << self
    def settings_table_exist?
      ActiveRecord::Base.connection.table_exists? ::Setting.table_name
    end
  end
end
