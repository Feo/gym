#encoding: utf-8
require 'net/http'
require 'digest/md5'

module API
  module V1
    class Coaches < Grape::API
      version 'v1'
      format :json

      resource :coaches do
        desc "Register a new coach"
        post 'register' do
          @coach = Coach.new(params[:coach])
          if !Coach.find_by_phone(params[:coach][:phone]).nil? || !Member.find_by_phone(params[:coach][:phone]).nil?
            error!({"error" => "该号码已被使用，请重新输入。", "status" => "f" }, 400)
         elsif !params[:coach][:phone].empty? && @coach.save!
            rand = rand(999999)
            content = "51练激活码：" + rand.to_s
            username = I18n.t('.smsbao.config.username')
            password = I18n.t('.smsbao.config.password')
            uri = URI('http://www.smsbao.com/sms')
            res = Net::HTTP.post_form(uri, 'u' => username, 'p' => password, 'm' => @coach.phone, 'c' => content )
            @coach.update_attributes(token:rand)
            present @coach
          else
            error!({"error" => "注册失败。", "status" => "f" }, 400)
          end
        end

        desc "Send activated token"
        post 'send_token' do
          @coach = Coach.find_by_phone(params[:coach][:phone])
          if !@coach.nil?
            rand = rand(999999)
            content = "51练激活码：" + rand.to_s
            username = I18n.t('.smsbao.config.username')
            password = I18n.t('.smsbao.config.password')
            uri = URI('http://www.smsbao.com/sms')
            res = Net::HTTP.post_form(uri, 'u' => username, 'p' => password, 'm' => @coach.phone, 'c' => content )
            @coach.update_attributes(token:rand)
            present @coach
          else
            error!({"error" => "该手机号未注册。", "status" => "f" }, 400)
          end
        end

        desc "Activate account"
        post 'activate_account' do
          @coach = Coach.find_by_phone(params[:coach][:phone])
          if !@coach.nil? && @coach.token == params[:coach][:token]
            @coach.update_attributes(activated:true)
            present @coach
          else
            error!({"error" => "激活账户失败。", "status" => "f" }, 400)
          end
        end

        desc "Reset password"
        post 'reset_password' do
          @coach = Coach.find_by_phone(params[:phone])
          if @coach.try(:token) != params[:token]
            error!({"error" => "手机号码或验证码错误。", "status" => "f" }, 400)
          elsif params[:password].empty? || params[:password] != params[:password_confirmation]
            error!({"error" => "密码修改错误。", "status" => "f" }, 400)
          elsif @coach.update_attributes(password:params[:password], password_confirmation:params[:password_confirmation])
            present @coach
          else
            error!({"error" => "密码修改错误。", "status" => "f" }, 400)
          end
        end

        desc "Coach login"
        post 'login' do
          @coach = Coach.find_by_phone(params[:session][:phone])
          if @coach && @coach.authenticate(params[:session][:password]) && @coach.activated
            sign_in_coach @coach
            present @coach
          elsif @coach && @coach.authenticate(params[:session][:password]) && !@coach.activated
            error!({"error" => "账户未激活。", "status" => "f" }, 400)
          else
            error!({"error" => "手机或密码错误。", "status" => "f" }, 400)
          end
        end

        before do
          authenticate_coach!
        end

        desc "Coach logout"
        post 'logout' do
          @coach = self.current_coach
          self.current_coach = nil
          cookies[:remember_token] = nil
          present @coach
        end

        desc "Update coach information"
        post 'update' do
          @coach = current_coach
          if @coach.update_attributes(params[:coach].except(:password, :password_confirmation))
            sign_in_coach @coach
            present @coach
          else
            error!({"error" => "修改教练信息不成功。", "status" => "f" }, 400)
          end
        end

        desc "change coach password"
        post 'change_pwd' do
          @coach = current_coach
          if params[:coach][:password].empty? || params[:coach][:password] != params[:coach][:password_confirmation]
            error!({"error" => "密码修改错误。" }, 400)
          elsif @coach.update_attributes(params[:member])
            sign_in_coach @coach
            present @coach
          else
            error!({"error" => "密码修改错误。", "status" => "f" }, 400)
          end
        end

        desc "Get current coach information"
        get 'info' do
          present current_coach
        end

        desc "Get certain coach information with id"
        get ':id/info' do
          @coach = Coach.find_by_id(params[:id])
          if @coach
            present @coach
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

        desc "Get apply member list"
        get 'apply_list' do
          @members = Member.where("coach_id = ? AND have_coach = ?", current_coach.id, false)
        end

        desc "Get related member list"
        get 'related_list' do
          @members = Member.where("coach_id = ? AND have_coach = ?", current_coach.id, true)
        end

        desc "Approve member's coach apply."
        post 'approve_apply' do
          @member = Member.where("coach_id = ? AND have_coach = ? AND id = ?", current_coach.id, false, params[:id]).first
          if @member
            @member.update_attributes(have_coach:true)
            sendno = Time.now.to_i
            receiver_value = @member.phone.to_s
            input = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value.to_s + I18n.t('.jpush.config.master_secret_member').to_s
            md5 = Digest::MD5.hexdigest(input)
            send_description = "批准关联申请"
            n_content = "教练：#{@member.name}，手机号：#{@member.phone}，已批准关联申请。"
            n_extras = Hash[:type => "message"]
            msg_content = Hash[:n_content => n_content, :n_extras => n_extras].to_json
            output = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                            :sendno => sendno,
                                                            :app_key => I18n.t('.jpush.config.app_key_member'),
                                                            :receiver_type => I18n.t('.jpush.config.receiver_type'),
                                                            :receiver_value => receiver_value,
                                                            :verification_code => md5,
                                                            :msg_type => I18n.t('.jpush.config.msg_type'),
                                                            :msg_content => msg_content,
                                                            :send_description => send_description,
                                                            :time_to_live => I18n.t('.jpush.config.time_to_live'),
                                                            :platform => I18n.t('.jpush.config.platform'))
            present @member
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

        desc "Refuse member's coach apply."
        post 'refuse_apply' do
          @member = Member.where("coach_id = ? AND have_coach = ? AND id = ?", current_coach.id, false, params[:id]).first
          if @member
            @member.update_attributes(coach_id:nil)
            sendno = Time.now.to_i
            receiver_value = @member.phone.to_s
            input = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value.to_s + I18n.t('.jpush.config.master_secret_member').to_s
            md5 = Digest::MD5.hexdigest(input)
            send_description = "拒绝关联申请"
            n_content = "教练：#{@member.name}，手机号：#{@member.phone}，拒绝关联申请。"
            n_extras = Hash[:type => "message"]
            msg_content = Hash[:n_content => n_content, :n_extras => n_extras].to_json
            output = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                            :sendno => sendno,
                                                            :app_key => I18n.t('.jpush.config.app_key_member'),
                                                            :receiver_type => I18n.t('.jpush.config.receiver_type'),
                                                            :receiver_value => receiver_value,
                                                            :verification_code => md5,
                                                            :msg_type => I18n.t('.jpush.config.msg_type'),
                                                            :msg_content => msg_content,
                                                            :send_description => send_description,
                                                            :time_to_live => I18n.t('.jpush.config.time_to_live'),
                                                            :platform => I18n.t('.jpush.config.platform'))
            present @member
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

        desc "Delete related member."
        post 'delete_member' do
          @member = Member.where("coach_id = ? AND have_coach = ? AND id = ?", current_coach.id, true, params[:id]).first
          if @member
            phone = current_coach.phone + ";"
            @member.update_attributes(coach_id:nil,
                                                                have_coach:false,
                                                                grade:nil,
                                                                grade_time:nil,
                                                                accuracy_grade:0.0,
                                                                appetency_grade:0.0,
                                                                professional_grade:0.0,
                                                                apply_coach:@member.apply_coach.to_s.split(/#{phone}/).first)
            present @member
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

        desc "Find members information"
        post 'find_member' do
          age_less = params[:member][:age_less] || ""
          if age_less.empty?
            age_less = 100
          end
          @members = Member.where("nickname like ?
                                                    AND name like ?
                                                    AND province like ?
                                                    AND city like ?
                                                    AND district like ?
                                                    AND street like ?
                                                    AND email like ?
                                                    AND phone like ?
                                                    AND gender like ?
                                                    AND profession like ?
                                                    AND age >= ?
                                                    AND age <= ?",
                                                    "%#{params[:member][:nickname]}%",
                                                    "%#{params[:member][:name]}%",
                                                    "%#{params[:member][:province]}%",
                                                   "%#{params[:member][:city]}%",
                                                   "%#{params[:member][:district]}%",
                                                   "%#{params[:member][:street]}%",
                                                   "%#{params[:member][:email]}%",
                                                   "%#{params[:member][:phone]}%",
                                                   "%#{params[:member][:gender]}%",
                                                   "%#{params[:member][:profession]}%",
                                                   "#{params[:member][:age_greater]}",
                                                   age_less)
          present @members
        end

        desc "Apply a coach"
        post 'apply_member' do
          @member = Member.find_by_id(params[:id])
          @coach = current_coach
          if @member.have_coach
            error!({"error" => "会员已有私教。", "status" => "f" }, 400)
          elsif @member
            if @member.apply_coach.to_s.include? @coach.phone
              error!({"error" => "已请求关联。", "status" => "f" }, 400)
            end
            apply_coach = @member.apply_coach.to_s + @coach.phone + ";"
            @member.update_attributes(apply_coach:apply_coach)
            sign_in_coach @coach
            sendno = Time.now.to_i
            receiver_value = @member.phone.to_s
            input = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value.to_s + I18n.t('.jpush.config.master_secret_member').to_s
            md5 = Digest::MD5.hexdigest(input)
            send_description = "申请关联会员"
            n_content = "教练：#{@coach.name}，手机号：#{@coach.phone}，申请关联会员。"
            n_extras = Hash[:type => "message"]
            msg_content = Hash[:n_content => n_content, :n_extras => n_extras].to_json
            output = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                            :sendno => sendno,
                                                            :app_key => I18n.t('.jpush.config.app_key_member'),
                                                            :receiver_type => I18n.t('.jpush.config.receiver_type'),
                                                            :receiver_value => receiver_value,
                                                            :verification_code => md5,
                                                            :msg_type => I18n.t('.jpush.config.msg_type'),
                                                            :msg_content => msg_content,
                                                            :send_description => send_description,
                                                            :time_to_live => I18n.t('.jpush.config.time_to_live'),
                                                            :platform => I18n.t('.jpush.config.platform'))
            
            present @member
          else
            error!({"error" => "会员ID错误。", "status" => "f" }, 400)
          end
        end


      end
    end
  end
end