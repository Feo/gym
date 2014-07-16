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
          if params[:coach][:password] != params[:coach][:password_confirmation]
            error!({"error" => "确认密码错误。" }, 400)
          elsif @coach.update_attributes(params[:coach])
            sign_in_coach @coach
            present @coach
          else
            error!({"error" => "修改教练信息不成功。" }, 400)
          end
        end

        desc "Get coach information"
        get 'info' do
          present current_coach
        end


      end
    end
  end
end