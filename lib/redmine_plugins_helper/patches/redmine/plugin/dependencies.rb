# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/yaml'

module RedminePluginsHelper
  module Patches
    module Redmine
      module Plugin
        module Dependencies
          common_concern

          DEPENDENCIES_FILE_BASENAMES = %w[yml yaml].map { |e| "dependencies.#{e}" }

          # @param other [Redmine::Plugin]
          # @return [Integer]
          def <=>(other)
            so = dependency?(other)
            os = other.dependency?(self)

            return 1 if so && !os
            return -1 if !so && os

            super
          end

          # @return [Array<Symbol>]
          def dependencies_ids
            load_dependencies_from_file
            dependencies_hash.keys
          end

          # @param other [Redmine::Plugin]
          # @return [Boolean]
          def dependency?(other)
            load_dependencies_from_file
            recursive_dependencies_ids.include?(other.id)
          end

          # @param plugin_name [Symbol]
          # @param arg [Hash, String]
          # @return [Boolean]
          def requires_redmine_plugin(plugin_name, arg)
            r = super
            dependencies_hash[plugin_name.to_sym] = arg
            r
          end

          private

          # @return [Hash<Symbol, Object>]
          def dependencies_hash
            @dependencies_hash ||= {}
          end

          # @return [Hash<Symbol, Object>]
          def dependencies_from_file
            r = dependencies_file.if_present({}) { |path| ::EacRubyUtils::Yaml.load_file(path) }
            r = r.map do |plugin_name, arg|
              [plugin_name.to_sym, (arg.is_a?(::Hash) ? arg.symbolize_keys : arg)]
            end
            r.to_h
          end

          # @return [Pathname, nil]
          def dependencies_file
            DEPENDENCIES_FILE_BASENAMES
              .lazy
              .map { |b| directory.to_pathname.join(b) }.select(&:file?).first
          end

          # @return [void]
          def load_dependencies_from_file
            return if @dependencies_from_file_loaded

            dependencies_from_file
              .each { |plugin_name, arg| requires_redmine_plugin(plugin_name, arg) }
            @dependencies_from_file_loaded = true
          end

          # @return [Set<Symbol>]
          def recursive_dependencies_ids
            ::EacRubyUtils::RecursiveBuilder
              .new(id) { |plugin_id| ::Redmine::Plugin.find(plugin_id).dependencies_ids }.result
          end
        end
      end
    end
  end
end
