module ApplicationHelper
  def check_controller(name)
    controller_name.eql?(name) ? 'active' : ''
  end
end
