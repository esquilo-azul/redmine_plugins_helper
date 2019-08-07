# frozen_string_literal: true

require 'redmine_plugins_helper/hooks/add_assets'
Rails.application.config.assets.precompile += %w[plugins_autoload.css plugins_autoload.js]
