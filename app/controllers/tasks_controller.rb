class TasksController < ApplicationController

  before_action :set_task, only: [:show, :edit, :update, :destroy]


  def index
    # @tasks = Task.all
    # @tasks = current_user.tasks.order(created_at: :desc)

    # これも同じ
    # @tasks = Task.where(user_id: current_user.id)

    # scope recentを使う
    # @tasks = current_user.tasks.recent

    # ransackを使って検索機能
    @q = current_user.tasks.ransack(params[:q])
    # gem kaminariを使ってページネーション。
    # デフォルト25件。perで５０に設定。これはmodelでもできる。
    # @tasks = @q.result(distinct: true).page(params[:page]).per(50)
    @tasks = @q.result(distinct: true).page(params[:page])



    # 一覧表示のindexに、異なるフォーマットでの出力機能を用意する
    # respond_to 返却するレスポンスのフォーマットを切り替えるためのメソッド
    # format.htmlはHTMLとしてアクセスされた場合（URL拡張子なしでアクセスされた場合）
    # format.csvはCSVとしてアクセスされた場合（/task.csvというURLでアクセスされた場合）
    respond_to do |format|
      # HTMLフォーマットについては特に処理指定してない。から、デフォルト動作としてindex.htm.slimが表示される
      format.html
      # CSVフォーマットの場合はsend_dataメソッドをつかってレスポンスを送り出し、
      # 送り出したデータをブラウザからファイルとしてダウンロードできるようにします。
      # レスポンス内容は、Task.genarate_csvが生成するCSVデータとしています。
      # ファイル名は、ダウンロードするたびに異なるファイル名になるように、現在時刻をつかって作成してる。
      format.csv {
        send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%dS')}.csv"
      }
    end
  end


  def show
    # @task = Task.find(params[:id])
    # @task = current_user.tasks.find(params[:id])
  end

  # 新規登録画面
  def new
    @task = Task.new
  end

  # 確認画面
  def confirm_new
    @task = current_user.tasks.new(task_prams)
    render :new unless @task.valid?
  end


  def create

    # オブジェクトを生成

    # merge 2つのハッシュの統合
    # @task = Task.new(task_prams.merge(user_id: current_user))

    # current_userのtaskにnewする
    @task = current_user.tasks.new(task_prams)

    # 上の2つ、どちらもログインしているユーザーのidをuser_idに入れた状態で、Taskデータに登録することができる。

    # 戻るボタンを押されたとき
    if params[:back].present?
      render :new
      return
    end

    # save!ではなくsaveを使う。戻り値によって制御をかえるため。save!だと例外を発生させるから。
    if @task.save

      # deliver_now 即時送信するメソッド
      TaskMailer.creation_email(@task).deliver_now
      # TaskMailer.creation_email(@task).deliver_now(wait: 5.minutes) # 5分後に送信

      # ジョブの呼び出し
      # perform_laterメソッド(ログ出力)で、非同期に実行。
      # ここでperform_laterは、ジョブの実行を予約するだけ（ジョブを登録するだけ）で、ジョブの開始や完了を待つことはない。
      # すぐに対応できない状態であれば、ジョブの処理は、処理できる状態になったら時点で開始される。
      SampleJob.perform_later
      # 翌日の正午ににジョブを実行
      # SampleJob.set(wait_unil: Date.tomorrow.noon).perform_later
      # 一週間後に実行
      # SampleJob.set(wait:1.week).perform_later



      # log関連

      # デバッグ用に、保存したタスクの情報をログに出力させたい場合。
      # logger.debug "タスク： #{@task.attributes.inspect}"
      # log/developments.log に出力
      logger.debug 'logger に出力'
      # logger.formatter.debug
      # log/custom.log に出力。なければ作成。
      Rails.application.config.custom_logger.debug 'custom_logger にも出力してる'
      # taskに関するログだけを専用ファイルに出力
      task_logger.debug 'taskのログを出力'




      flash[:notice] = "タスク「#{@task.name}」を登録しました。"
      redirect_to task_url @task
    else
      render :new
    end

  end


  def edit
    # @task = Task.find(params[:id])
    # @task = current_user.tasks.find(params[:id])
  end

  def update
    # task = Task.find(params[:id])
    # task = current_user.tasks.find(params[:id])
    @task.update!(task_prams)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  def destroy
    # task = Task.find(params[:id]).destroy
    # task = current_user.tasks.find(params[:id]).destroy

    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}を削除しました。」"
  end


  # オリジナルのロガー taskに関するログだけファイル出力
  def task_logger
    @task_logger ||= Logger.new('log/task.log', 'daily')
  end

  def import
    # アップロードされたファイルオブジェクトを引数に、関連越しにmodelに追加したimportメソッドを呼び出す。
    # これにより、アップロードされたファイルの内容を、ログインしているユーザーのタスク郡として登録することができる。
    current_user.tasks.import(params[:file])
    # インポートが終わったあとにタスク一覧画面に遷移する。
    redirect_to tasks_url, notice: "タスクを追加しました"
  end


  private

  # ストロングパラメーター
  def task_prams
    # permitで指定したものだけ変更を加える
    params.require(:task).permit(:name, :description, :image)
  end

  def set_task
    # params[:id]からタスクオブジェクトを検索して@taskに代入する
    @task = current_user.tasks.find(params[:id])
  end

end
