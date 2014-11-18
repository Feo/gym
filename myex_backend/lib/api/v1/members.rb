#encoding: utf-8
require 'net/http'
require 'digest/md5'

module API
  module V1
    class Members < Grape::API
      version 'v1'
      format :json

      resource :members do
        desc "Register a new member"
        post 'register' do
          @member = Member.new(params[:member])
          if !Member.find_by_phone(params[:member][:phone]).nil? || !Coach.find_by_phone(params[:member][:phone]).nil?
            error!({"error" => "该号码已被使用，请重新输入。", "status" => "f" }, 400)
         elsif !params[:member][:phone].empty? && @member.save
            rand = rand(999999)
            content = "51练激活码：" + rand.to_s
            username = I18n.t('.smsbao.config.username')
            password = I18n.t('.smsbao.config.password')
            uri = URI('http://www.smsbao.com/sms')
            res = Net::HTTP.post_form(uri, 'u' => username, 'p' => password, 'm' => @member.phone, 'c' => content )
            @member.update_attributes(token:rand)
            present @member
          else
            error!({"error" => "注册失败。", "status" => "f" }, 400)
          end
        end

        # old register
        # post 'register' do
        #   @member = Member.new(params[:member])
        #   if !Member.find_by_email(params[:member][:email]).nil?
        #     error!({"error" => "该邮箱已被使用，请重新输入。", "status" => "f" }, 400)
        #   elsif @member.save
        #     sign_in_member @member
        #     present @member
        #   else
        #     error!({"error" => "注册失败。", "status" => "f" }, 400)
        #   end
        # end

        desc "Send activated token"
        post 'send_token' do
          @member = Member.find_by_phone(params[:member][:phone])
          if !@member.nil?
            rand = rand(999999)
            content = "51练激活码：" + rand.to_s
            username = I18n.t('.smsbao.config.username')
            password = I18n.t('.smsbao.config.password')
            uri = URI('http://www.smsbao.com/sms')
            res = Net::HTTP.post_form(uri, 'u' => username, 'p' => password, 'm' => @member.phone, 'c' => content )
            @member.update_attributes(token:rand)
            present @member
          else
            error!({"error" => "该手机号未注册。", "status" => "f" }, 400)
          end
        end

        desc "Activate account"
        post 'activate_account' do
          @member = Member.find_by_phone(params[:member][:phone])
          if !@member.nil? && @member.token == params[:member][:token]
            @member.update_attributes(activated:true)
            present @member
          else
            error!({"error" => "激活账户失败。", "status" => "f" }, 400)
          end
        end

        desc "Reset password"
        post 'reset_password' do
          @member = Member.find_by_phone(params[:phone])
          if @member.try(:token) != params[:token]
            error!({"error" => "手机号码或验证码错误。", "status" => "f" }, 400)
          elsif params[:password].empty? || params[:password] != params[:password_confirmation]
            error!({"error" => "密码修改错误。", "status" => "f" }, 400)
          elsif @member.update_attributes(password:params[:password], password_confirmation:params[:password_confirmation])
            present @member
          else
            error!({"error" => "密码修改错误。", "status" => "f" }, 400)
          end
        end

        desc "Member login"
        post 'login' do
          @member = Member.find_by_phone(params[:session][:phone])
          if @member && @member.authenticate(params[:session][:password]) && @member.activated
            sign_in_member @member
            present @member
          elsif @member && @member.authenticate(params[:session][:password]) && !@member.activated
            error!({"error" => "账户未激活。", "status" => "f" }, 400)
          else
            error!({"error" => "手机或密码错误。", "status" => "f" }, 400)
          end
        end

        before do
          authenticate_member!
        end

        desc "Member logout"
        post 'logout' do
          @member = self.current_member
          self.current_member = nil
          cookies[:remember_token] = nil
          present @member
        end

        desc "Update member information"
        post 'update' do
          @member = current_member
          if @member.update_attributes(params[:member].except(:password, :password_confirmation))
            sign_in_member @member
            present @member
          else
            error!({"error" => "修改会员信息不成功。", "status" => "f" }, 400)
          end
        end

        desc "change member password"
        post 'change_pwd' do
          @member = current_member
          if params[:member][:password].empty? || params[:member][:password] != params[:member][:password_confirmation]
            error!({"error" => "密码修改错误。", "status" => "f" }, 400)
          elsif @member.update_attributes(params[:member])
            sign_in_member @member
            present @member
          else
            error!({"error" => "密码修改错误。", "status" => "f" }, 400)
          end
        end

        desc "Get current member information"
        get 'info' do
          present current_member
        end

        desc "Get certain member information with id"
        get ':id/info' do
          @member = Member.find_by_id(params[:id])
          if @member
            present @member
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

        desc "Find coaches information"
        post 'find_coach' do
          age_less = params[:coach][:age_less] || ""
          if age_less.empty?
            age_less = 100
          end
          experience_less = params[:coach][:experience_less] || ""
          if experience_less.empty?
            experience_less = 100
          end
          grade_less = params[:coach][:grade_less] || ""
          if grade_less.empty?
            grade_less = 100
          end
          @coaches = Coach.where("nickname like ?
                                                    AND name like ?
                                                    AND province like ?
                                                    AND city like ?
                                                    AND district like ?
                                                    AND street like ?
                                                    AND email like ?
                                                    AND gender like ?
                                                    AND profession like ?
                                                    AND organization like ?
                                                    AND age >= ?
                                                    AND age <= ?
                                                    AND experience >= ?
                                                    AND experience <= ?
                                                    AND grade >= ?
                                                    AND grade <= ?",
                                                    "%#{params[:coach][:nickname]}%",
                                                    "%#{params[:coach][:name]}%",
                                                    "%#{params[:coach][:province]}%",
                                                   "%#{params[:coach][:city]}%",
                                                   "%#{params[:coach][:district]}%",
                                                   "%#{params[:coach][:street]}%",
                                                   "%#{params[:coach][:email]}%",
                                                   "%#{params[:coach][:gender]}%",
                                                   "%#{params[:coach][:profession]}%",
                                                   "%#{params[:coach][:organization]}%",
                                                   "#{params[:coach][:age_greater]}",
                                                   age_less,
                                                   "#{params[:coach][:experience_greater]}",
                                                   experience_less,
                                                   "#{params[:coach][:grade_greater]}",
                                                   grade_less)
          present @coaches
        end

        desc "Apply a private coach"
        post 'apply_coach' do
          @coach = Coach.find_by_id(params[:id])
          @member = current_member
          if @member.have_coach
            error!({"error" => "会员已有私教。", "status" => "f" }, 400)
          elsif @coach
            @member.update_attributes(coach_id:params[:id])
            sign_in_member @member
            sendno = Time.now.to_i
            receiver_value = @coach.phone.to_s
            input = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value.to_s + I18n.t('.jpush.config.master_secret_coach').to_s
            md5 = Digest::MD5.hexdigest(input)
            send_description = "申请关联教练"
            n_content = "会员：#{@member.name}，手机号：#{@member.phone}，申请关联教练。"
            n_extras = Hash[:type => "message"]
            msg_content = Hash[:n_content => n_content, :n_extras => n_extras].to_json
            output = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                            :sendno => sendno,
                                                            :app_key => I18n.t('.jpush.config.app_key_coach'),
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
            error!({"error" => "教练ID错误。", "status" => "f" }, 400)
          end
        end

        desc "Delete the current private coach"
        post 'delete_coach' do
          @member = current_member
          if !@member.have_coach
            error!({"error" => "会员没有关联的私教。", "status" => "f" }, 400)
          else
            @coach = Coach.find_by_id(params[:id])
            if !@coach
              error!({"error" => "教练ID错误。", "status" => "f" }, 400)
            end
            phone = @coach.phone + ";"
            @member.update_attributes(coach_id:nil,
                                                                have_coach:false,
                                                                grade:nil,
                                                                grade_time:nil,
                                                                accuracy_grade:0.0,
                                                                appetency_grade:0.0,
                                                                professional_grade:0.0,
                                                                apply_coach:@member.apply_coach.to_s.split(/#{phone}/).first)
            sign_in_member @member
            present @member
          end
        end

        desc "Get the current private coach information"
        get 'current_coach' do
          @member = current_member
          if @member.have_coach
            @coach = Coach.find_by_id(@member.coach_id)
            present @coach
          else
            error!({"error" => "会员没有关联的私教。", "status" => "f" }, 400)
          end
        end

        desc "Get the coach information"
        post 'coach_info' do
          @coach = Coach.find_by_id(params[:id])
          if @coach
            present @coach
          else
            error!({"error" => "教练ID错误。", "status" => "f" }, 400)
          end
        end

        desc "Grading the current private coach"
        post 'grade_coach' do
          @member = current_member
          if !@member.have_coach
            error!({"error" => "会员没有关联的私教。", "status" => "f" }, 400)
          elsif false#@member.grade_time && Time.now - @member.grade_time < 1.month
            error!({"error" => "一个月内只能修改一次。", "status" => "f" }, 400)
          else
            @member.update_attributes(accuracy_grade:params[:accuracy_grade],
                                                                appetency_grade:params[:appetency_grade],
                                                                professional_grade:params[:professional_grade],
                                                                grade:(params[:accuracy_grade] + params[:appetency_grade] + params[:professional_grade]),
                                                                grade_time:Time.now)
            @members = Member.where("have_coach = ? AND coach_id = ? AND grade is not null", true, @member.coach_id)
            total_accuracy_grade = 0
            total_appetency_grade = 0
            total_professional_grade = 0
            @members.each do |member|
              total_accuracy_grade = total_accuracy_grade + member.accuracy_grade
              total_appetency_grade = total_appetency_grade + member.appetency_grade
              total_professional_grade = total_professional_grade + member.professional_grade
            end
            @coach = Coach.find_by_id(@member.coach_id)
            coach_accuracy_grade = (total_accuracy_grade/@members.count).round(1)
            coach_appetency_grade = (total_appetency_grade/@members.count).round(1)
            coach_professional_grade = (total_professional_grade/@members.count).round(1)
            @coach.update_attributes(accuracy_grade:coach_accuracy_grade,
                                                            appetency_grade:coach_appetency_grade,
                                                            professional_grade:coach_professional_grade,
                                                            grade:(coach_accuracy_grade + coach_appetency_grade + coach_professional_grade))

            coach_count = Coach.where("grade != ?", 0).count
            level1 =  (coach_count * 0.1).ceil
            level2 =  (coach_count * 0.3).ceil
            level3 =  (coach_count * 0.7).ceil
            level4 =  (coach_count * 0.9).ceil
            level5 =  (coach_count * 1).ceil
            if Coach.where("grade != ?", 0).order("grade DESC").first(level1).include? @coach
              level = "1"
            elsif Coach.where("grade != ?", 0).order("grade DESC").first(level2).include? @coach
              level = "2"
            elsif Coach.where("grade != ?", 0).order("grade DESC").first(level3).include? @coach
              level = "3"
            elsif Coach.where("grade != ?", 0).order("grade DESC").first(level4).include? @coach
              level = "4"
            elsif Coach.where("grade != ?", 0).order("grade DESC").first(level5).include? @coach
              level = "5"
            end
            @coach.update_attributes(level:level)

            sign_in_member @member
            present [@member, @coach]
          end
        end

        desc "Get apply coach list"
        get 'apply_list' do
          @coaches = []
          if !current_member.apply_coach.to_s.empty?
            current_member.apply_coach.to_s.split(/;/).each do |phone|
              @coaches << Coach.find_by_phone(phone)
            end
          end
          present @coaches
        end

        desc "Approve coach's apply."
        post 'approve_apply' do
          @member = current_member
          @coach = Coach.find_by_id(params[:id])
          if !@member.have_coach
            @member.update_attributes(have_coach:true, coach_id:@coach.id)
            sendno = Time.now.to_i
            receiver_value = @coach.phone.to_s
            input = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value.to_s + I18n.t('.jpush.config.master_secret_coach').to_s
            md5 = Digest::MD5.hexdigest(input)
            send_description = "申请关联教练"
            n_content = "会员：#{@member.name}，手机号：#{@member.phone}，同意关联教练。"
            n_extras = Hash[:type => "message"]
            msg_content = Hash[:n_content => n_content, :n_extras => n_extras].to_json
            output = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                            :sendno => sendno,
                                                            :app_key => I18n.t('.jpush.config.app_key_coach'),
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
            error!({"error" => "会员已关联教练。", "status" => "f" }, 400)
          end
        end
        

        desc "Refuse coach's apply."
        post 'refuse_apply' do
          @member = current_member
          @coach = Coach.find_by_id(params[:id])
          if @member
            phone = @coach.phone + ";"
            @member.update_attributes(apply_coach:@member.apply_coach.to_s.split(/#{phone}/).first)
            sendno = Time.now.to_i
            receiver_value = @coach.phone.to_s
            input = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value.to_s + I18n.t('.jpush.config.master_secret_coach').to_s
            md5 = Digest::MD5.hexdigest(input)
            send_description = "申请关联教练"
            n_content = "会员：#{@member.name}，手机号：#{@member.phone}，拒绝关联教练。"
            n_extras = Hash[:type => "message"]
            msg_content = Hash[:n_content => n_content, :n_extras => n_extras].to_json
            output = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                            :sendno => sendno,
                                                            :app_key => I18n.t('.jpush.config.app_key_coach'),
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

      end
    end
  end
end