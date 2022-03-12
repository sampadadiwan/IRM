# Sidekiq.configure_server do |config|
#   config.on :startup do
#     require 'prometheus_exporter/instrumentation'
#     PrometheusExporter::Instrumentation::ActiveRecord.start(
#       custom_labels: { type: "sidekiq" }, # optional params
#       config_labels: %i[database host] # optional params
#     )
#   end
# end

# Sidekiq.configure_server do |config|
#   require 'prometheus_exporter/instrumentation'
#   config.server_middleware do |chain|
#     chain.add PrometheusExporter::Instrumentation::Sidekiq
#   end
#   config.death_handlers << PrometheusExporter::Instrumentation::Sidekiq.death_handler
#   config.on :startup do
#     PrometheusExporter::Instrumentation::Process.start type: 'sidekiq'
#     PrometheusExporter::Instrumentation::SidekiqProcess.start
#     PrometheusExporter::Instrumentation::SidekiqQueue.start
#     PrometheusExporter::Instrumentation::SidekiqStats.start
#   end
# end

# Sidekiq.configure_server do |_config|
#   at_exit do
#     PrometheusExporter::Client.default.stop(wait_timeout_seconds: 10)
#   end
# end
