# encoding: utf-8
module AdminRightsHelper


  def controller_names
    @controller_names ||= ControllerName::Right.values.inject({}){|f,s| f.merge(s)}
  end

  def show_right(data)
    data.inject({}){|f, s| f.merge(controller_names[s['c']] => s['r'] ? "读" : "写" )}
  end
  
end
