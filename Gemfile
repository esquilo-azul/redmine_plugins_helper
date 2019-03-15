Dir.glob File.expand_path('../*', __dir__) do |plugin|
  next unless ::File.directory?(plugin)

  gemspec = ::File.join(plugin, "#{::File.basename(plugin)}.gemspec")
  gem ::File.basename(plugin), path: plugin if ::File.exist?(gemspec)
end
