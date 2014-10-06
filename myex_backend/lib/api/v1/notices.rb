#encoding: utf-8

module API
  module V1
    class Notices < Grape::API
      version 'v1'
      format :json

      resource :notices do

        before do
          authenticate!
        end

        desc "Create a new notice."
        post 'create' do
          @notice = Notice.new(params[:notice])
          if @notice.save
            present @notice
          else
            error!({"error" => "创建通知失败。", "status" => "f" }, 400)
          end
        end

        
        desc "Delete a notice."
        post 'delete' do
          @notice = Notice.find_by_id(params[:id])
          if @notice
            @notice.destroy
            present @notice
          else
            error!({"error" => "删除通知失败。", "status" => "f" }, 400)
          end
        end

        desc "Get current coach's all notices."
        get 'coach_notice' do
          @notices = Notice.where("coach_phone like ?", "%#{current_coach.phone}%")
        end

        desc "Get current member's all notices."
        get 'member_notice' do
          @notices = Notice.where("member_phone like ?", "%#{current_member.phone}%")
        end

        desc "Delete current coach's all notice."
        post 'delete_coach_all' do
          @notices = Notice.where("coach_phone like ?", "%#{current_coach.phone}%")
          @notices.each do |notice|
            notice.destroy
          end
          present @notices
        end

        desc "Delete current member's all notice."
        post 'delete_member_all' do
          @notices = Notice.where("member_phone like ?", "%#{current_member.phone}%")
          @notices.each do |notice|
            notice.destroy
          end
          present @notices
        end

        desc "Get a notice."
        get ':id' do
          @notice = Notice.find_by_id(params[:id])
          if @notice
            present @notice
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

      end
    end
  end
end