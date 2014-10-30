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

  def forget_password
    @admin = Administrator.new
  end

  def send_token
    @admin = Administrator.find_by_phone(params[:administrator][:phone])
    if @admin
      rand = rand(999999)
      content = "51练验证码：" + rand.to_s
      username = I18n.t('.smsbao.config.username')
      password = I18n.t('.smsbao.config.password')
      uri = URI('http://www.smsbao.com/sms')
      res = Net::HTTP.post_form(uri, 'u' => username, 'p' => password, 'm' => @admin.phone, 'c' => content )
      @admin.update_attributes(token:rand)
      flash[:success] = "验证码发送成功。"
      redirect_to  reset_sessions_path
    else
      flash[:error] = '该手机号不存在。'
      redirect_to forget_password_sessions_path
    end
  end

  def reset
    @admin = Administrator.new
  end

  def reset_password
    @admin = Administrator.find_by_phone(params[:administrator][:phone])
    if @admin && params[:administrator][:token] == @admin.token && !params[:administrator][:password].to_s.empty? && params[:administrator][:password].to_s == params[:administrator][:password_confirmation].to_s &&@admin.update_attributes(password:params[:administrator][:password], password_confirmation:params[:administrator][:password])
      flash[:success] = "重置密码成功，请登录。"
      redirect_to  new_session_url
    else
      flash[:success] = "重置密码失败。"
      redirect_to  reset_sessions_path
    end
    
  end

end
