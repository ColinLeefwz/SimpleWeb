# coding: utf-8

class AdminAppLogsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"
  
end
