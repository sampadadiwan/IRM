unless Rails.env.test?
  require 'prometheus_exporter/middleware'

  # This reports stats per request like HTTP status and timings
  Rails.application.middleware.unshift PrometheusExporter::Middleware
end

# in an initializer
unless Rails.env.test?
  require 'prometheus_exporter/instrumentation'

  # this reports basic process stats like RSS and GC info
  PrometheusExporter::Instrumentation::Process.start(type: "master")
end
