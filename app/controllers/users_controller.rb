class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to mypage_path, notice: "プロフィールを更新しました"
    else
      flash.now["danger"] = "プロフィールの更新が失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def set_user
    Rails.logger.debug "Current user ID: #{current_user.id}"
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :name, :budget, :people, :introduction, :avatar, :avatar_cache)
  end
end
