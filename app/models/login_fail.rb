# coding: utf-8

class LoginFail
  include Mongoid::Document
  field :name
  field :password
  field :login_at
  field :ip
  field :agent

end

