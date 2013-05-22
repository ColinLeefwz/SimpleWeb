# encoding: utf-8
module AdminRightsHelper
  def yaml_data
    @yaml_data ||= YAML.load_file(Rails.root.to_s+"/config/locales/contro.yml")
  end

  def controller_names
    @controller_names ||= yaml_data["right"].values.inject({}){|f,s| f.merge(s)}
  end

  def show_right(data)
    data.inject({}){|f, s| f.merge(controller_names[s['c']] => s['r'] ? "读" : "写" )}
  end
  
end
