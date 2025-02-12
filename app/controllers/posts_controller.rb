class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @posts = Post.includes(:user, :menu, :shopping_lists)
  end

  def mypage
    @posts = current_user.posts.order(created_at: :desc)
  end

  def new
    @post_form = PostForm.new
  end

  def create
    @post_form = PostForm.new(post_form_params)
    @post_form.user_id = current_user.id  # ログインユーザーをセット
Rails.logger.debug "PostForm Params: #{params[:post_form].inspect}"
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

  def destroy
    board = current_user.posts.find(params[:id])
    board.destroy!
    redirect_to posts_path, notice: "投稿を削除しました", status: :see_other
  end

  private

  def post_form_params
    params.require(:post_form).permit(
      :sum, :memo,  # Post の属性
      :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday,  # Menu の属性
      shopping_list_items: [ :name, :category ]
    )
  end
end
