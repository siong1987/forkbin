class UsersController < ApplicationController
  def show
    if user = User.where(username: params[:id]).first
      @lists = user.lists.where(is_public: true).all
      render json: Rabl::Renderer.json(@lists, 'lists/index', view_path: 'app/views')
    else
      render json: Rabl::Renderer.json(nil, 'lists/index', view_path: 'app/views')
    end
  end
end
