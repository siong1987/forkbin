class ForksController < ApplicationController
  def index
    @old_list = List.find(params[:list_id])
    @forks = @old_list.parent.lists.where(is_public: true).all

    render json: Rabl::Renderer.json(@forks, 'lists/index', view_path: 'app/views')
  end
end
