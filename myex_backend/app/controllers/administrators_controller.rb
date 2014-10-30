#encoding: utf-8
class AdministratorsController < ApplicationController
  before_filter :signed_in

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

  def message_index
    @notice = Notice.new
  end

  def message_create_all
    @coaches = Coach.all
    coaches = ""
    @coaches.each do |coach|
      coaches << coach.phone + ";"
    end
    @notice = Notice.new(title:params[:notice][:title], content:params[:notice][:content], category:params[:notice][:category], coach_phone:coaches)
    if @notice.save
      sendno = Time.now.to_i
      receiver_value_coach = coaches.gsub(/;/, ',')
      input_coach = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value_coach.to_s + I18n.t('.jpush.config.master_secret_coach').to_s
      md5_coach = Digest::MD5.hexdigest(input_coach)
      send_description = "创建新消息"
      n_content = "标题：#{params[:notice][:title]};内容：#{params[:notice][:content]}"
      n_extras = Hash[:type => params[:notice][:category]]
      msg_content = Hash[:n_content => n_content, :n_extras => n_extras].to_json
      output_coach = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                      :sendno => sendno,
                                                      :app_key => I18n.t('.jpush.config.app_key_coach'),
                                                      :receiver_type => I18n.t('.jpush.config.receiver_type'),
                                                      :receiver_value => receiver_value_coach,
                                                      :verification_code => md5_coach,
                                                      :msg_type => I18n.t('.jpush.config.msg_type'),
                                                      :msg_content => msg_content,
                                                      :send_description => send_description,
                                                      :time_to_live => I18n.t('.jpush.config.time_to_live'),
                                                      :platform => I18n.t('.jpush.config.platform'))
      flash[:success] = "消息发送成功。"
      redirect_to notices_administrators_path
    else
      flash[:error] = "消息发送失败。"
      redirect_to notices_administrators_path
    end
  end

  def notices
    @notices = Notice.all
  end

  def notice_show
    @notice = Notice.find(params[:format])
  end

  def notice_special_view
    @notice = Notice.new
    @coaches = Coach.all
  end

  def message_create_special
    coaches = ""
    params[:phones].each do |phone|
      coaches << phone + ";"
    end
    @notice = Notice.new(title:params[:notice][:title], content:params[:notice][:content], category:params[:notice][:category], coach_phone:coaches)
    if @notice.save
      sendno = Time.now.to_i
      receiver_value_coach = coaches.gsub(/;/, ',')
      input_coach = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value_coach.to_s + I18n.t('.jpush.config.master_secret_coach').to_s
      md5_coach = Digest::MD5.hexdigest(input_coach)
      send_description = "创建新消息"
      n_content = "标题：#{params[:notice][:title]};内容：#{params[:notice][:content]}"
      n_extras = Hash[:type => params[:notice][:category]]
      msg_content = Hash[:n_content => n_content, :n_extras => n_extras].to_json
      output_coach = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                      :sendno => sendno,
                                                      :app_key => I18n.t('.jpush.config.app_key_coach'),
                                                      :receiver_type => I18n.t('.jpush.config.receiver_type'),
                                                      :receiver_value => receiver_value_coach,
                                                      :verification_code => md5_coach,
                                                      :msg_type => I18n.t('.jpush.config.msg_type'),
                                                      :msg_content => msg_content,
                                                      :send_description => send_description,
                                                      :time_to_live => I18n.t('.jpush.config.time_to_live'),
                                                      :platform => I18n.t('.jpush.config.platform'))
      flash[:success] = "消息发送成功。"
      redirect_to notices_administrators_path
    else
      flash[:error] = "消息发送失败。"
      redirect_to notices_administrators_path
    end
  end

  def notice_all_member
    @notice = Notice.new
  end

  def notice_all_member_create
    @members = Member.all
    phones = ""
    @members.each do |member|
      phones << member.phone + ";"
    end
    @notice = Notice.new(title:params[:notice][:title], content:params[:notice][:content], category:params[:notice][:category], member_phone:phones)
    if @notice.save
      sendno = Time.now.to_i
      receiver_value_member = phones.gsub(/;/, ',')
      input_member = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value_member.to_s + I18n.t('.jpush.config.master_secret_member').to_s
      md5_member = Digest::MD5.hexdigest(input_member)
      send_description = "创建新消息"
      n_content = "标题：#{params[:notice][:title]};内容：#{params[:notice][:content]}"
      n_extras = Hash[:type => params[:notice][:category]]
      msg_content = Hash[:n_content => n_content, :n_extras => n_extras].to_json
      output_member = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                      :sendno => sendno,
                                                      :app_key => I18n.t('.jpush.config.app_key_member'),
                                                      :receiver_type => I18n.t('.jpush.config.receiver_type'),
                                                      :receiver_value => receiver_value_member,
                                                      :verification_code => md5_member,
                                                      :msg_type => I18n.t('.jpush.config.msg_type'),
                                                      :msg_content => msg_content,
                                                      :send_description => send_description,
                                                      :time_to_live => I18n.t('.jpush.config.time_to_live'),
                                                      :platform => I18n.t('.jpush.config.platform'))
      flash[:success] = "消息发送成功。"
      redirect_to notices_administrators_path
    else
      flash[:error] = "消息发送失败。"
      redirect_to notices_administrators_path
    end
  end

  def notice_special_member
    @notice = Notice.new
    @members = Member.all
  end

  def notice_special_member_create
    phones = ""
    params[:phones].each do |phone|
      phones << phone + ";"
    end
    @notice = Notice.new(title:params[:notice][:title], content:params[:notice][:content], category:params[:notice][:category], member_phone:phones)
    if @notice.save
      sendno = Time.now.to_i
      receiver_value_member = phones.gsub(/;/, ',')
      input_member = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value_member.to_s + I18n.t('.jpush.config.master_secret_member').to_s
      md5_member = Digest::MD5.hexdigest(input_member)
      send_description = "创建新消息"
      n_content = "标题：#{params[:notice][:title]};内容：#{params[:notice][:content]}"
      n_extras = Hash[:type => params[:notice][:category]]
      msg_content = Hash[:n_content => n_content, :n_extras => n_extras].to_json
      output_member = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                      :sendno => sendno,
                                                      :app_key => I18n.t('.jpush.config.app_key_member'),
                                                      :receiver_type => I18n.t('.jpush.config.receiver_type'),
                                                      :receiver_value => receiver_value_member,
                                                      :verification_code => md5_member,
                                                      :msg_type => I18n.t('.jpush.config.msg_type'),
                                                      :msg_content => msg_content,
                                                      :send_description => send_description,
                                                      :time_to_live => I18n.t('.jpush.config.time_to_live'),
                                                      :platform => I18n.t('.jpush.config.platform'))
      flash[:success] = "消息发送成功。"
      redirect_to notices_administrators_path
    else
      flash[:error] = "消息发送失败。"
      redirect_to notices_administrators_path
    end
  end
end
