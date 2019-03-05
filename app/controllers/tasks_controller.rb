class TasksController < ApplicationController

  before_action :set_task, only: [:show, :edit, :update, :destroy]


  def index
    # @tasks = Task.all
    # @tasks = current_user.tasks.order(created_at: :desc)

    # scope recentを使う
    @tasks = current_user.tasks.recent

    # これも同じ
    # @tasks = Task.where(user_id: current_user.id)
  end

  def show
    # @task = Task.find(params[:id])
    # @task = current_user.tasks.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create

    # オブジェクトを生成

    # merge 2つのハッシュの統合
    # @task = Task.new(task_prams.merge(user_id: current_user))

    # current_userのtaskにnewする
    @task = current_user.tasks.new(task_prams)

    # 上の2つ、どちらもログインしているユーザーのidをuser_idに入れた状態で、Taskデータに登録することができる。


    # save!ではなくsaveを使う。戻り値によって制御をかえるため。save!だと例外を発生させるから。
    if @task.save
      flash[:notice] = "タスク「#{@task.name}」を登録しました。"
      redirect_to tasks_url
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


  private

  # ストロングパラメーター

  def task_prams
    # permitで指定したものだけ変更を加える
    params.require(:task).permit(:name, :description)
  end

  def set_task
    # params[:id]からタスクオブジェクトを検索して@taskに代入する
    @task = current_user.tasks.find(params[:id])
  end

end
