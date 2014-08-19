module API
  module V1
    class Coaches < Grape::API
      version 'v1'
      format :json

      resource :coaches do
        desc "Register a new coach"
        post 'register' do
          @coach = Coach.new(params[:coach])
          if !Coach.find_by_email(params[:coach][:email]).nil?
            error!({"error" => "该邮箱已被使用，请重新输入。" }, 400)
          elsif @coach.save
            sign_in_coach @coach
            present @coach
          else
            error!({"error" => "注册失败。" }, 400)
          end
        end

        desc "Coach login"
        post 'login' do
          @coach = Coach.find_by_email(params[:session][:email].downcase)
          if params[:session][:password] != params[:session][:password_confirmation]
            error!({"error" => "邮箱或密码错误。" }, 400)
          elsif @coach && @coach.authenticate(params[:session][:password])
            sign_in_coach @coach
            present @coach
          else
            error!({"error" => "邮箱或密码错误。" }, 400)
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
          if @coach.update_attributes(params[:coach].slice(params[:coach][:email], params[:coach][:password], params[:coach][:password_confirmation]))
            sign_in_coach @coach
            present @coach
          else
            error!({"error" => "修改教练信息不成功。" }, 400)
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
            error!({"error" => "密码修改错误。" }, 400)
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
            error!({"error" => "ID错误。" }, 400)
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
            present @member
          else
            error!({"error" => "ID错误。" }, 400)
          end
        end

        desc "Refuse member's coach apply."
        post 'refuse_apply' do
          @member = Member.where("coach_id = ? AND have_coach = ? AND id = ?", current_coach.id, false, params[:id]).first
          if @member
            @member.update_attributes(coach_id:nil)
            present @member
          else
            error!({"error" => "ID错误。" }, 400)
          end
        end

        desc "Delete related member."
        post 'delete_member' do
          @member = Member.where("coach_id = ? AND have_coach = ? AND id = ?", current_coach.id, true, params[:id]).first
          if @member
            @member.update_attributes(coach_id:nil, have_coach:false)
            present @member
          else
            error!({"error" => "ID错误。" }, 400)
          end
        end

      end
    end
  end
end