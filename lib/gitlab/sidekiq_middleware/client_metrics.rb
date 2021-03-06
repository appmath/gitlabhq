# frozen_string_literal: true

module Gitlab
  module SidekiqMiddleware
    class ClientMetrics < SidekiqMiddleware::Metrics
      ENQUEUED = :sidekiq_enqueued_jobs_total

      def initialize
        @metrics = init_metrics
      end

      def call(worker, _job, queue, _redis_pool)
        labels = create_labels(worker.class, queue)

        @metrics.fetch(ENQUEUED).increment(labels, 1)

        yield
      end

      private

      def init_metrics
        {
          ENQUEUED => ::Gitlab::Metrics.counter(ENQUEUED, 'Sidekiq jobs enqueued')
        }
      end
    end
  end
end
