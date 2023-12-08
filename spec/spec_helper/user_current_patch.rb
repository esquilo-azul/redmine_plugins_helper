# frozen_string_literal: true

require_dependency 'user'

module UserCurrentPatch
  ORIGINAL_METHOD_PREFIX = 'original_'
  PATCHED_METHOD_PREFIX = 'patched_'
  METHODS_TO_PATCH = %w[current current=].freeze

  def self.extended(base)
    METHODS_TO_PATCH.each do |method|
      base.singleton_class.alias_method "#{ORIGINAL_METHOD_PREFIX}#{method}", method
      base.singleton_class.alias_method method, "#{PATCHED_METHOD_PREFIX}#{method}"
    end
  end

  def patched_current
    patched_current_user || User.anonymous
  end

  def patched_current=(user)
    self.patched_current_user = user
  end

  private

  attr_accessor :patched_current_user
end

User.extend UserCurrentPatch

RSpec.configure do |config|
  config.after do
    User.current = nil
  end
end
