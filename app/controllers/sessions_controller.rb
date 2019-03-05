class SessionsController < ApplicationController

  # skip_before_actionメソッドを使えば、特定のアクションでフィルタをスキップできる。
  # ApplicationControllerのbefore_actionに記述してある、login_required（ログイン済みかどうかチェック）を、
  # SessionsControllerは適用しないようにする。
  skip_before_action :login_required


  def new
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました。'
    else
      render :new
    end
  end

  def destroy
    # すべてのセッション情報を削除
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end



  private

  # ストロングパラメーター
  def session_params
    params.require(:session).permit(:email, :password)
  end


end
