class FavoritesController < ApplicationController
  def create
    @ai_generate = AiGenerate.find(params[:ai_generate_id])
    current_user.favorite(@ai_generate)
  end

  def destroy
    @ai_generate = current_user.favorites.find(params[:id]).ai_generate
    current_user.unfavorite(@ai_generate)
  end
end
