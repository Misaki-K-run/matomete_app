class AiGeneratesController < ApplicationController
  before_action :check_ai_usage_limit, only: [ :create ]

  def new
    @ai_generate = AiGenerate.new
  end

  def create
    @ai_generate = current_user.ai_generates.new(ai_generate_params)

    # サービスクラスを呼び出し、AIでデータを生成
    ai_results = AiGenerateService.new(
      budget_request: @ai_generate.budget_request,
      people_request: @ai_generate.people_request,
      allergies: @ai_generate.allergies,
      favorite_ingredients: @ai_generate.favorite_ingredients,
      special_request: @ai_generate.special_request
    ).call

    # 生成されたデータを保存
    @ai_generate.assign_attributes(ai_results)

    if @ai_generate.save
      redirect_to ai_generate_path(@ai_generate), notice: "献立を作成しました！"
    else
      flash.now[:alert] = "献立を作成できませんでした。"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @ai_generate = AiGenerate.find(params[:id])
  end

  def favorites
    @favorite_ai_generates = current_user.favorite_ai_generates.includes(:user).order(created_at: :desc).page(params[:page])
  end

  private

  def ai_generate_params
    params.require(:ai_generate).permit(:budget_request, :people_request, :allergies, :favorite_ingredients, :special_request)
  end

  def check_ai_usage_limit
    if current_user.ai_usage_date == Date.today && current_user.ai_usage_count >= 3
      flash[:alert] = "今日はすでに3回AIを使用しました。明日また試してください。"
      redirect_to ai_generates_path
    else
      if current_user.ai_usage_date != Date.today
        current_user.update(ai_usage_count: 0, ai_usage_date: Date.today)
      end
      current_user.increment!(:ai_usage_count)
    end
  end
end
