class AiGeneratesController < ApplicationController

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
      redirect_to ai_generate_path(@ai_generate)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @ai_generate = AiGenerate.find(params[:id])
    # 必要な情報をビューに渡す
  end

  private

  def ai_generate_params
    params.require(:ai_generate).permit(:budget_request, :people_request, :allergies, :favorite_ingredients, :special_request)
  end

end
