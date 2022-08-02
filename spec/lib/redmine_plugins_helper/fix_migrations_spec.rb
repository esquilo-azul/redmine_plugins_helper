# frozen_string_literal: true

require 'redmine_plugins_helper/fix_migrations'

::RSpec.describe ::RedminePluginsHelper::FixMigrations do
  before do
    ::ActiveRecord::SchemaMigration.delete_all
    ::ActiveRecord::SchemaMigration.create!(version: '20220802172154')
    ::ActiveRecord::SchemaMigration.create!(version: '20170828182204-my_plugin')
  end

  it do
    expect(::ActiveRecord::SchemaMigration.count).not_to eq(0)
  end

  it do
    expect { described_class.new }.not_to raise_error
  end
end
