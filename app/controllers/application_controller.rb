class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  # devise ログインの確認
  before_action :authenticate_user!
end
