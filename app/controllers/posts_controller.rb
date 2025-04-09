class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
            .includes(:user, :menu, :shopping_lists)
            .order(created_at: :desc)
            .page(params[:page])

    # メタタグを設定する。
    prepare_meta_tags(@post)
  end

  def mypage
    @posts = current_user.posts.order(created_at: :desc).page(params[:page])
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
      Rails.logger.debug @post_form.errors.full_messages
      flash.now[:alert] = "投稿できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post= Post.find(params[:id])
    @user = @post.user
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
      Rails.logger.debug @post.errors.full_messages
      flash.now[:alert] = "投稿を更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    redirect_to posts_path, notice: "投稿を削除しました", status: :see_other
  end

  def bookmarks
    @bookmark_posts = current_user.bookmark_posts.includes(:user).order(created_at: :desc).page(params[:page])
  end

  private

  def post_form_params
    params.require(:post_form).permit(
      :sum, :memo,
      :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday,
      shopping_list_items: [ :name, :category ]
    )
  end

  def prepare_meta_tags(post)
    image_url = "#{request.base_url}/images/ogp.png?text=投稿一覧"

    set_meta_tags og: {
                      site_name: "matomete",
                      title: "投稿一覧 - matomete",
                      description: "一週間分の献立表と買い物リストをまとめて作成した投稿一覧ページ",
                      type: "website",
                      url: request.original_url,
                      image: image_url,
                      locale: "ja-JP"
                    },
                  twitter: {
                      card: "summary_large_image",
                      image: image_url
                    }
  end
end
