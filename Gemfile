# frozen_string_literal: true

require 'pathname'
helper_root = Pathname.new('.').expand_path(__dir__)
redmine_root = Pathname.new('../..').expand_path(helper_root)
plugins_root = redmine_root / 'plugins'
plugins_root.each_child.sort.each do |plugin|
  gemfile = plugin.join('Gemfile')
  next if gemfile.exist? && gemfile.to_path != __FILE__
  next unless (plugin / "#{plugin.basename}.gemspec").file?

  gem plugin.basename.to_s, path: plugin.relative_path_from(helper_root).to_s
end
