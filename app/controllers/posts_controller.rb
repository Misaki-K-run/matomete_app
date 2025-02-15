class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user, :menu, :shopping_lists)
  end

  def mypage
    @posts = current_user.posts.order(created_at: :desc)
  end

  def new
    @post_form = PostForm.new
  end

  def create
    @post_form = PostForm.new(post_form_params)
    @post_form.user_id = current_user.id

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

  def edit
    @post = current_user.posts.find(params[:id])
    @post_form = PostForm.new(
      memo: @post.memo,
      sum: @post.sum,
      monday: @post.menu&.monday,
      tuesday: @post.menu&.tuesday,
      wednesday: @post.menu&.wednesday,
      thursday: @post.menu&.thursday,
      friday: @post.menu&.friday,
      saturday: @post.menu&.saturday,
      sunday: @post.menu&.sunday,
      shopping_list_items: @post.shopping_lists.map { |item| { name: item.name, category: item.category } }
    )
  end

  def update
    @post = current_user.posts.find(params[:id])
    @post_form = PostForm.new(post_form_params)

    if @post_form.update(@post)
      redirect_to posts_path, notice: "投稿を更新できました"
    else
      flash.now[:alert] = "投稿を更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
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
