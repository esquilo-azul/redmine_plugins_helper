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

      def table?(table_name)
        database? && ::ActiveRecord::Base.connection.table_exists?(table_name)
      end
    end
  end
end
