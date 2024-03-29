# frozen_string_literal: true

require 'redmine_plugins_helper/patches/redmine/plugin'

RSpec.describe Redmine::Plugin do
  describe '#by_path' do
    let(:found) { described_class.by_path(__FILE__) }
    let(:not_found) { described_class.by_path(Rails.root.join('plugin/no_exist_abc123')) }

    it { expect(found).to eq(described_class.registered_plugins[:redmine_plugins_helper]) }
    it { expect(not_found).to be_nil }
  end
end
