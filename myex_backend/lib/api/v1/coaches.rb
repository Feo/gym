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
            present @coach
          else
            error!({"error" => "注册失败。" }, 400)
          end
        end
      end
    end
  end
end