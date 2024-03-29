# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module RedminePluginsHelper
  module Patches
    module Redmine
      module Plugin
        module Initializers
          def load_initializers
            Dir["#{initializers_directory}/*.rb"].sort.each { |f| require f }
          end

          private

          def initializers_directory
            File.join(directory, 'config', 'initializers')
          end
        end
      end
    end
  end
end
