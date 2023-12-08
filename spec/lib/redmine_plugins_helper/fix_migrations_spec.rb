# frozen_string_literal: true

require 'redmine_plugins_helper/fix_migrations'

RSpec.describe RedminePluginsHelper::FixMigrations do
  before do
    ActiveRecord::SchemaMigration.delete_all
  end

  it { expect(ActiveRecord::SchemaMigration.count).to eq(0) }

  context 'with database versions' do
    let(:database_versions) do
      %w[20220102030401 20220102030402-redmine_plugins_helper 20220102030403-other_plugin
         20220102030404-redmine_plugins_helper]
    end

    before do
      database_versions.each do |version|
        ActiveRecord::SchemaMigration.create!(version: version)
      end
    end

    it do
      expect(sorted_database_versions).to eq(database_versions)
    end

    context 'when fix' do
      let(:local_versions) do
        [
          [nil, 20_220_102_030_401],
          [:redmine_plugins_helper, 20_220_102_030_402],
          [:redmine_plugins_helper, 20_220_102_030_403]

        ].to_h { |lv| [lv[1], [{ plugin: lv[0], timestamp: lv[1], version: "#{lv[1]}-#{lv[0]}" }]] }
      end

      let(:instance) do
        r = described_class.new
        allow(r).to receive(:local_versions) { local_versions }
        r
      end

      before do
        instance.perform
      end

      it do
        expect(instance.send(:local_versions)).to eq(local_versions)
      end

      it 'fixes database versions' do
        expect(sorted_database_versions).to(
          eq(%w[20220102030401 20220102030402-redmine_plugins_helper
                20220102030403-redmine_plugins_helper 20220102030404-redmine_plugins_helper])
        )
      end
    end
  end

  def sorted_database_versions
    ActiveRecord::SchemaMigration.order(version: :asc).pluck(:version)
  end
end
