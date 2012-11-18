class ListsController < ApplicationController
  before_filter :authenticate_user!, except: [ :show ]

  def index
    @lists = current_user.lists.all
    render json: Rabl::Renderer.json(@lists, 'lists/index', view_path: 'app/views')
  end

  def create
    @list = current_user.lists.new(params[:list])
    @list.parent = Parent.create

    if @list.save
      render json: Rabl::Renderer.json(@list, 'lists/show', view_path: 'app/views'), status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def fork
    @old_list = List.find(params[:list_id])

    if @old_list.is_public
      # if user is forking his/her own list, just return the list
      if @existing_list = @old_list.parent.lists.where(user_id: current_user.id).first
        render json: Rabl::Renderer.json(@existing_list, 'lists/show', view_path: 'app/views'), status: :created
        return
      end

      @list = current_user.lists.new(@old_list.attributes)

      if @list.save
        @list.parent.update_attribute(:fork_count, @list.parent.fork_count + 1)

        items = @old_list.items.map do |i|
          {name: i.k, checked: i.v}
        end
        @list.update_items(items)
        render json: Rabl::Renderer.json(@list, 'lists/show', view_path: 'app/views'), status: :created
      else
        render json: @list.errors, status: :unprocessable_entity
      end
    else
      render json: nil, status: :unprocessable_entity
    end
  end

  def show
    @list = List.find(params[:id])

    if @list.is_public
      render json: Rabl::Renderer.json(@list, 'lists/show', view_path: 'app/views')
    elsif @list.user == current_user
      render json: Rabl::Renderer.json(@list, 'lists/show', view_path: 'app/views')
    else
      render json: nil, status: :unprocessable_entity
    end
  end

  def update
    @list = current_user.lists.find(params[:id])

    if @list.update_attributes(params[:list])
      render json: Rabl::Renderer.json(@list, 'lists/show', view_path: 'app/views'), status: :ok
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def update_items
    @list = current_user.lists.find(params[:list_id])

    if @list.update_items(params[:items].map{ |k,v| v })
      render json: Rabl::Renderer.json(@list, 'lists/show', view_path: 'app/views'), status: :ok
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @list = current_user.lists.find(params[:id])
    parent = @list.parent
    @list.destroy

    parent.update_attribute(:fork_count, parent.fork_count - 1)

    render json: nil, status: :ok
  end
end
