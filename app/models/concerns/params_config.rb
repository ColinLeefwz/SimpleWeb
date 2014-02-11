module ParamsConfig
  extend ActiveSupport::Concern

  def to_param
    permalink
  end

  protected
  def permalink
    "#{id}-#{title.parameterize}"
  end
end
