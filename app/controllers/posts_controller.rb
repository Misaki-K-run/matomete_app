class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @posts = Post.includes(:user, :menu, :shopping_lists)
  end

  def new
    @post_form = PostForm.new

  end

  def create
    @post_form = PostForm.new(post_form_params)
    @post_form.user_id = current_user.id  # ログインユーザーをセット

    Rails.logger.debug("POSTリクエストが送信されました: #{@post_form.inspect}")

    if @post_form.save
      @post = @post_form.post
      Rails.logger.debug("Postが保存されました: #{@post_form.post.inspect}")
      redirect_to posts_path, notice: "投稿できました"
    else
      Rails.logger.debug("Post Form Errors: #{@post_form.errors.full_messages}")
      flash.now[:alert] = "投稿できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post= Post.find(params[:id])
  end

  def add_item
     @post = Post.find(params[:post_id])
    @post_form = PostForm.new(post_form_params)
    @post_form.user_id = current_user.id  # ログインユーザーをセット

    if @post_form.create_shopping_list(@post)  # アイテムの追加
      @post = @post_form.post  # 保存した Post オブジェクトを取得

      @items = ShoppingList.where(post_id: @post.id)


    render turbo_stream: [
      turbo_stream.append("shopping_list", partial: "shopping_lists/item", locals: { items: @items }),
      turbo_stream.replace("shopping_list_form", partial: "posts/form", locals: { post_form: PostForm.new })  # 新しいフォームに置き換える
    ]
    else
      flash.now[:alert] = "アイテムの追加に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_form_params
    params.require(:post_form).permit(
      :sum, :memo,  # Post の属性
      :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday,  # Menu の属性
      :meat_fish, :vegetable, :other
    )
  end
end
