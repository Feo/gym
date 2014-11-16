#encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  private
  
    def signed_in
      unless signed_in?
        store_location
        redirect_to root_path, :notice => "请先登录." 
      end
    end
  
end
