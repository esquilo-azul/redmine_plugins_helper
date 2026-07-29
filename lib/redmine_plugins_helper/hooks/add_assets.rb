# frozen_string_literal: true

module RedminePluginsHelper
  module Hooks
    class AddAssets < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(_context = {})
        safe_join([plugins_autoload_stylesheet_tag, plugins_autoload_script_tag])
      end

      private

      def plugins_autoload_stylesheet_tag
        tag.link(
          media: 'all',
          rel: 'stylesheet',
          href: asset_path(::RedminePluginsHelper::PluginsAutoloadAssets::CSS_OUTPUT_SUBPATH)
        )
      end

      def plugins_autoload_script_tag
        content_tag(
          'script',
          "\n",
          src: asset_path(::RedminePluginsHelper::PluginsAutoloadAssets::JS_OUTPUT_SUBPATH)
        )
      end
    end
  end
end
