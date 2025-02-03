class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @posts = Post.includes(:user)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "投稿できました"
    else
      flash.now[:alert] = "投稿できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:sum, :memo)
  end
end
