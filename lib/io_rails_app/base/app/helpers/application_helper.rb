module ApplicationHelper

  def show_nav_active(controller, action)
    'active' if params[:action] == action && params[:controller] == controller
  end

end
