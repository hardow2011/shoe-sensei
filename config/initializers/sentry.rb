# frozen_string_literal: true

# TODO: put sentry dsn in secret
Sentry.init do |config|
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.dsn = "https://9c6332cfe3e4677d0e52cc772d2e14d0@o4506474750869504.ingest.us.sentry.io/4507909763104768"
  config.enable_tracing = true
  # TODO: find out what those values are
  config.traces_sample_rate = 1.0
  config.profiles_sample_rate = 1.0
  config.enabled_environments = %w[production]
end
