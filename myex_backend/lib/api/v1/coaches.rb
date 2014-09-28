#encoding: utf-8

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
          []
        end

        desc "Approve member's coach apply."
        post 'approve_apply' do
          @member = Member.where("coach_id = ? AND have_coach = ? AND id = ?", current_coach.id, false, params[:id]).first
          if @member
            @member.update_attributes(have_coach:true)
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
            present @member
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

        desc "Delete related member."
        post 'delete_member' do
          @member = Member.where("coach_id = ? AND have_coach = ? AND id = ?", current_coach.id, true, params[:id]).first
          if @member
            @member.update_attributes(coach_id:nil, have_coach:false)
            present @member
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

      end
    end
  end
end