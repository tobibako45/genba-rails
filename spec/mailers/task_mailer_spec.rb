require 'rails_helper'

describe TaskMailer, type: :mailer do

  # 共通的なデータとしてtaskというletを用意する
  let(:task) {
    FactoryBot.create(:task, name: 'メイラーSpecを書く', description: '送信したメールの内容を確認します')
  }

  # 生成されるメールを mail という名前で参照できるように想定してるが、
  # このmailからtext形式とhtml形式のbodyの内容を手軽に得られるようにするために、
  # text_body、html_bodyというletを用意しておく
  let(:text_body) do
    part = mail.body.parts.detect {
        |part| part.content_type == 'text/plain; charset=UTF-8'
    }
    part.body.raw_source
  end
  let(:html_body) do
    part = mail.body.parts.detect {
        |part| part.content_type == 'text/html; charset=UTF-8'
    }
    part.body.raw_source
  end

  # creation_email(タスク登録のメール通知を受け取るメソッド)
  describe '#creation_email' do
    # creation_emailを使ってメールを生成し、生成したメールオブジェクトを mail という名前で参照できるようにするletを定義する。
    let(:mail) {
      TaskMailer.creation_email(task)
    }

    it '想定どおりのメールが生成されている' do
      # ヘッダ
      expect(mail.subject).to eq('タスク作成完了メール')
      expect(mail.to).to eq(['user@example.com'])
      expect(mail.from).to eq(['taskleaf@example.com'])
      # textの本文
      expect(text_body).to match('以下のタスクを作成しました')
      expect(text_body).to match('メイラーSpecを書く')
      expect(text_body).to match('送信したメールの内容を確認します')
      # htmlの本文
      expect(html_body).to match('以下のタスクを作成しました')
      expect(html_body).to match('メイラーSpecを書く')
      expect(html_body).to match('送信したメールの内容を確認します')
    end

  end

end