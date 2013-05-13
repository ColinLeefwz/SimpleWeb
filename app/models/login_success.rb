# coding: utf-8

class LoginSuccess
  include Mongoid::Document
  field :name
  field :login_at
  field :ip
  field :agent

end

