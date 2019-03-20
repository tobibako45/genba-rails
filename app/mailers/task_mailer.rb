class TaskMailer < ApplicationMailer
  # デフォルトのfromを設定
  default from: 'taskleaf@example.com'

  # タスク登録のメール通知を受け取るメソッド
  def creation_email(task)

    @task = task
    mail(
      subject: 'タスク作成完了メール', # タイトル
      to: 'user@example.com', # 宛先
      from: 'taskleaf@example.com' # 送信者
    )
  end
end
