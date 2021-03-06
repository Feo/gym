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

        
        desc "Coach delete a notice."
        post 'coach_delete' do
          @notice = Notice.find_by_id(params[:id])
          if @notice
            var = current_coach.phone + ";"
            coach_phone = @notice.coach_phone
            coach_phone.slice!(/#{var}/)
            @notice.update_attributes(coach_phone:coach_phone + ";")
            @notice.update_attributes(coach_phone:@notice.coach_phone[0...-1])
            present @notice
          else
            error!({"error" => "删除通知失败。", "status" => "f" }, 400)
          end
        end

        desc "Member delete a notice."
        post 'member_delete' do
          @notice = Notice.find_by_id(params[:id])
          if @notice
            var = current_member.phone + ";"
            member_phone = @notice.member_phone
            member_phone.slice!(/#{var}/)
            @notice.update_attributes(member_phone:member_phone + ";")
            @notice.update_attributes(member_phone:@notice.member_phone[0...-1])
            present @notice
          else
            error!({"error" => "删除通知失败。", "status" => "f" }, 400)
          end
        end

        desc "Get current coach's all notices."
        post 'coach_notice' do
          @notices = Notice.where("coach_phone like ? AND category = ?", "%#{current_coach.phone}%", params[:category])
        end

        desc "Get current member's all notices."
        post 'member_notice' do
          @notices = Notice.where("member_phone like ? AND category = ?", "%#{current_member.phone}%", params[:category])
        end

        desc "Delete current coach's all notice."
        post 'delete_coach_all' do
          @notices = Notice.where("coach_phone like ?", "%#{current_coach.phone}%")
          var = current_coach.phone + ";"
          @notices.each do |notice|
            coach_phone = notice.coach_phone
            coach_phone.slice!(/#{var}/)

            notice.update_attributes(coach_phone:coach_phone + ";")
            notice.update_attributes(coach_phone:notice.coach_phone[0...-1])
          end
          present @notices
        end

        desc "Delete current member's all notice."
        post 'delete_member_all' do
          @notices = Notice.where("member_phone like ?", "%#{current_member.phone}%")
          var = current_member.phone + ";"
          @notices.each do |notice|
            member_phone = notice.member_phone
            member_phone.slice!(/#{var}/)

            notice.update_attributes(member_phone:member_phone + ";")
            notice.update_attributes(member_phone:notice.member_phone[0...-1])
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