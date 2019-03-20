class SampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # 処理が行われてことを把握しやすくするため、Sidekiqのログにメッセージを表示
    Sidekiq::Logging.logger.info "サンプルジョブを実行しました"
  end
end
