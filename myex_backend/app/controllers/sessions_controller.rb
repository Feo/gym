#encoding: utf-8

class SessionsController < ApplicationController

  def new
  end

  def create
    @admin = Administrator.find_by_phone(params[:session][:phone])
    if @admin && @admin.authenticate(params[:session][:password])
      @admin.update_attributes(last_login:Time.now)
      sign_in @admin
      flash[:success] = "用户登录成功。"
      redirect_to  administrator_path(@admin)
    else
      flash[:error] = '邮箱或者密码错误。'
      redirect_to new_session_url
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
