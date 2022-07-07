# frozen_string_literal: true

module RedminePluginsHelper
  module Available
    class << self
      def database?
        ::ActiveRecord::Base.connection
      rescue ActiveRecord::NoDatabaseError
        false
      else
        true
      end

      def model?(model_class)
        table?(model_class.table_name)
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
