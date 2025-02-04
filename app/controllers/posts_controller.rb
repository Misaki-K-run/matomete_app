class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @posts = Post.includes(:user, :menu)
  end

  def new
    @post_form = PostForm.new
  end

  def create
    @post_form = PostForm.new(post_form_params)
    @post_form.user_id = current_user.id  # ログインユーザーをセット

    if @post_form.save
      redirect_to posts_path, notice: "投稿できました"
    else
      flash.now[:alert] = "投稿できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_form_params
    params.require(:post_form).permit(
      :sum, :memo,  # Post の属性
      :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday,  # Menu の属性
      #:items # ShoppingList の属性
    )
  end
end
