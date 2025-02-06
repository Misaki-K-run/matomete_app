class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @posts = Post.includes(:user, :menu, :shopping_list)
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

  def show
    @post= Post.find(params[:id])
  end

    # アイテムを追加
    def add_item
      @post_form = PostForm.new(post_form_params)

      if params[:add_meat_fish].present?
        @post_form.add_meat_fish(params[:add_meat_fish])
      elsif params[:add_vegetable].present?
        @post_form.add_vegetable(params[:add_vegetable])
      elsif params[:add_other].present?
        @post_form.add_other(params[:add_other])
      end

      respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('shopping_list', partial: 'posts/shopping_list', locals: { post_form: @post_form }) }
      end
    end

  private

  def post_form_params
    params.require(:post_form).permit(
      :sum, :memo,  # Post の属性
      :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday,  # Menu の属性
      :meat_fish, :vegetable, :other  # カンマ区切りの文字列で受け取る
    )
  end
end
