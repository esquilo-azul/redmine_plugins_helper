# frozen_string_literal: true

require 'sprockets'
require 'sprockets/rails/context'
require 'sassc'
require 'sassc/rails/version'
require 'sassc/rails/functions'
require 'sassc/rails/importer'
require 'sassc/rails/template'

module RedminePluginsHelper
  # Compiles "plugins_autoload.css"/".js", bundling every registered Redmine plugin's main
  # stylesheet/javascript asset, and writes the result as static files that Propshaft serves.
  class PluginsAutoloadAssets
    include ::Singleton

    enable_memoized

    CSS_OUTPUT_SUBPATH = 'plugins_autoload.css'
    JS_OUTPUT_SUBPATH = 'plugins_autoload.js'
    OUTPUT_DIRECTORY_SUBPATH = 'tmp/plugins_autoload_assets'

    # @return [void]
    def generate
      Rails.application.config.sass = ActiveSupport::OrderedOptions.new
      output_directory.join(CSS_OUTPUT_SUBPATH).write(environment[CSS_OUTPUT_SUBPATH].to_s)
      output_directory.join(JS_OUTPUT_SUBPATH).write(environment[JS_OUTPUT_SUBPATH].to_s)
    end

    # @return [Pathname]
    memoize def output_directory
      Rails.root.join(OUTPUT_DIRECTORY_SUBPATH).tap do |v|
        v.mkpath
        paths = ::Rails.application.config.assets.paths
        paths << v.to_s unless paths.include?(v.to_s)
      end
    end

    protected

    # @return [Sprockets::Environment]
    def environment # rubocop:disable Metrics/AbcSize
      Sprockets::Environment.new.tap do |env|
        env.register_transformer('text/scss', 'text/css', ::SassC::Rails::ScssTemplate.new)
        env.register_transformer('text/sass', 'text/css', ::SassC::Rails::SassTemplate.new)
        env.context_class.class_eval { include ::Sprockets::Rails::Context }
        env.context_class.assets_prefix = ::Rails.application.config.assets.prefix
        env.context_class.config = ::Rails.application.config.action_controller
        source_paths.each { |path| env.append_path(path) }
      end
    end

    # @return [Pathname]
    def self_assets_directory
      __FILE__.to_pathname.dirname.dirname.dirname.join('app/assets')
    end

    # Reuses the same load paths Propshaft already collected from every engine/gem
    # (app/assets, lib/assets, vendor/assets) plus the ones "add_assets_paths" added for
    # each Redmine plugin.
    #
    # @return [Enumerable<String>]
    def source_paths
      [self_assets_directory.join('stylesheets').to_path,
       self_assets_directory.join('javascripts').to_path] +
        ::Rails.application.config.assets.paths
    end
  end
end
