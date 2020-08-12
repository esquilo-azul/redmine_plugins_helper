# frozen_string_literal: true

module RedminePluginsHelper
  class TestConfig
    def before_each
      mailer_setup
    end

    def after_each
      mailer_teadown
    end

    def mailer_setup
      unless @mailer_perform_deliveries_changed
        @mailer_perform_deliveries_changed = true
        @mailer_perform_deliveries_was_enabled = ::ActionMailer::Base.perform_deliveries
      end
      ::ActionMailer::Base.perform_deliveries = false
    end

    def mailer_teadown
      return unless @mailer_perform_deliveries_changed

      ::ActionMailer::Base.perform_deliveries = @mailer_perform_deliveries_was_enabled
      @mailer_perform_deliveries_changed = false
    end
  end
end
