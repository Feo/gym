module API
  module V1
    class Members < Grape::API
      version 'v1'
      format :json

      resource :members do
        desc "Register a new member"
        post 'register' do
          @member = Member.new(params[:member])
          if !Member.find_by_email(params[:member][:email]).nil?
            error!({"error" => "该邮箱已被使用，请重新输入。" }, 400)
          elsif @member.save
            sign_in_member @member
            present @member
          else
            error!({"error" => "注册失败。" }, 400)
          end
        end

        desc "Member login"
        post 'login' do
          @member = Member.find_by_email(params[:session][:email].downcase)
          if params[:session][:password] != params[:session][:password_confirmation]
            error!({"error" => "邮箱或密码错误。" }, 400)
          elsif @member && @member.authenticate(params[:session][:password])
            sign_in_member @member
            present @member
          else
            error!({"error" => "邮箱或密码错误。" }, 400)
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
          if params[:member][:password] != params[:member][:password_confirmation]
            error!({"error" => "确认密码错误。" }, 400)
          elsif @member.update_attributes(params[:member])
            sign_in_member @member
            present @member
          else
            error!({"error" => "修改会员信息不成功。" }, 400)
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
            error!({"error" => "ID错误。" }, 400)
          end
        end

      end
    end
  end
end