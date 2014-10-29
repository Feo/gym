#encoding: utf-8
class AdministratorsController < ApplicationController
  def show
    begin
      @admin = Administrator.find(params[:id])
    rescue
      redirect_to (current_admin), :notice => "该用户不存在."
    end
  end

  def update
    @admin = Administrator.find(params[:id])
    if @admin != current_admin && current_admin.role.to_s != "高级管理员".to_s
      flash[:error] = "只有高级管理员才能修改其他管理员。"
      redirect_to @admin
    elsif params[:administrator][:password].to_s.empty? || params[:administrator][:password] != params[:administrator][:password_confirmation]
      flash[:error] = "密码错误。"
      redirect_to @admin
    elsif @admin && @admin.update_attributes(params[:administrator])
      flash[:success] = "管理员信息更新成功。"
      sign_in @admin
      redirect_to @admin
    else
      flash[:error] = "管理员信息更新失败。"
      redirect_to @admin
    end
  end

  def index
    @admins = Administrator.all
    @admins.delete(current_admin)
    @admin = Administrator.new
  end

  def create
    @admin = Administrator.new(params[:administrator])
    if current_admin.role != "高级管理员"
      flash[:success] = "只有高级管理员才能创建新管理员。"
      redirect_to current_admin
    elsif @admin.save
      flash[:success] = "管理员创建成功。"
      redirect_to administrators_path
    else
      flash[:error] = "管理员创建失败。"
      redirect_to administrators_path
    end
  end

  def destroy
    @admin = Administrator.find(params[:id])
    if @admin.destroy
      flash[:success] = "管理员删除成功。"
      redirect_to administrators_path
    else
      flash[:error] = "管理员创建失败。"
      redirect_to administrators_path
    end
  end
end
