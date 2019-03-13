class ApplicationController < ActionController::Base
  # protect_from_forgery with: :null_session

  # ユーザーごとに言語を切り替える（仮定実装）
  # before_action :set_locale

  # helper_method指定することで、ビューで使えるようになる
  helper_method :current_user

  # current_userが空（ログインしていなければ）ログイン画面にリダイレクト
  before_action :login_required


  private

  def current_user
    # session[:user_id]がtrueで、@current_userが空のとき、
    # Userモデルからsession[:user_id]で検索して、@current_userに代入
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    # current_userが空（ログインしていなければ）ログイン画面にリダイレクト
    redirect_to login_path unless current_user
  end

  def set_locale
    # ログインしていなければ日本語
    I18n.locale = current_user&.locale || :ja
  end


end
