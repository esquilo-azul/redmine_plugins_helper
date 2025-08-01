# frozen_string_literal: true

module RedminePluginsHelper
  module Available
    class << self
      def database?
        ::ActiveRecord::Base.connection
      rescue ActiveRecord::NoDatabaseError, PG::ConnectionBad
        false
      else
        true
      end

      def database_schema?
        database? && ::RedminePluginsHelper::Migration.from_code.all?(&:applied?)
      end

      def model?(*model_classes)
        table?(*model_classes.map(&:table_name))
      end

      def table?(*table_names)
        return false unless database?

        table_names.all? { |table_name| ::ActiveRecord::Base.connection.table_exists?(table_name) }
      end

      def settings?
        model?(::Setting)
      end
    end
  end
end
