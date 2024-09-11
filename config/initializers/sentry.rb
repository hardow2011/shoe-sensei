# frozen_string_literal: true

# TODO: put sentry dsn in secret
Sentry.init do |config|
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.dsn = ENV['SENTRY_DSN']
  config.enable_tracing = true
  # TODO: find out what those values are
  config.traces_sample_rate = 1.0
  config.profiles_sample_rate = 1.0
  config.enabled_environments = %w[production]
end
