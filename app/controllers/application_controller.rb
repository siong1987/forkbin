class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :pushstate

private
  # enable pushstate
  def pushstate
    if request.format.html?
      if (request.path =~ /^(\/logout$|\/login$|\/signup$|\/users)/) != 0
        render_index
      end
    end
  end

  def render_index
    render 'welcome/index'
    return
  end
end
