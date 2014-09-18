module API
  module V1
    class Events < Grape::API
      version 'v1'
      format :json

      resource :events do

        before do
          authenticate!
        end

        desc "Coach create  a event."
        post 'coach_create' do
          @event = Event.new(params[:event])
          if @event.update_attributes(coach_id:current_coach.id, coach_approved:true)
            present @event
          else
            error!({"error" => "创建日程失败。", "status" => "f" }, 400)
          end
        end

        desc "Member approve the event"
        post 'member_approve' do
          @event = Event.find_by_id(params[:id])
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          elsif @event.member_phone.to_s.include?(current_member.phone) && !@event.member_approved.to_s.include?(current_member.phone)
            member_approved = @event.member_approved.to_s + current_member.phone + ";"
            @event.update_attributes(member_approved:member_approved)
            present @event
          else
            error!({"error" => "该用户没有操作此日程权限。", "status" => "f" }, 400)
          end
        end

        desc "Member refuse the event"
        post 'member_refuse' do
          @event = Event.find_by_id(params[:id])
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          elsif @event.member_phone.to_s.include?(current_member.phone) && !@event.member_approved.to_s.include?(current_member.phone)
            var = current_member.phone + ";"
            member_phone = @event.member_phone
            member_phone.slice!(/#{var}/)

            @event.update_attributes(member_phone:member_phone + ";")
            @event.update_attributes(member_phone:@event.member_phone[0...-1])
            present @event
          else
            error!({"error" => "该用户没有操作此日程权限。", "status" => "f" }, 400)
          end
        end

        desc "Member get all waiting events"
        get 'member_waiting_events' do
          var = current_member.phone + ";"
          @events = Event.where("member_phone like ? AND member_approved not like ?", "%#{var}%", "%#{var}%")
        end

        desc "Member get all approved events"
        get 'member_approved_events' do
          var = current_member.phone + ";"
          @events = Event.where("member_phone like ? AND member_approved like ?", "%#{var}%", "%#{var}%")
        end

        desc "Coach update  a event."
        post 'coach_update' do
          @event = Event.where("coach_id = ? AND id = ?", current_coach.id, params[:id]).first
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          elsif @event.update_attributes(params[:event])
            present @event
          else
            error!({"error" => "更新日程失败。", "status" => "f" }, 400)
          end
        end

        desc "Member update  a event."
        post 'member_update' do
          var = current_member.phone + ";"
          @event = Event.where("member_phone like ? AND id = ?", "%#{var}%", params[:id]).first
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          elsif @event.update_attributes(params[:event])
            member_phone = params[:event][:member_phone] + current_member.phone + ";"
            @event.update_attributes(member_phone:member_phone)
            present @event
          else
            error!({"error" => "更新日程失败。", "status" => "f" }, 400)
          end
        end

        desc "Coach delete a event"
        post 'coach_delete' do
          @event = Event.where("coach_id = ? AND id = ?", current_coach.id, params[:id]).first
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          else
            @event.destroy
            present @event
          end
        end

        desc "Member delete a event"
        post 'member_delete' do
          var = current_member.phone + ";"
          @event = Event.where("member_phone like ? AND id = ?", "%#{var}%", params[:id]).first
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          else
            member_phone = @event.member_phone
            member_approved = @event.member_approved
            member_phone.slice!(/#{var}/)
            member_approved.slice!(/#{var}/)

            @event.update_attributes(member_phone:member_phone + ";", member_approved:member_approved + ";")
            @event.update_attributes(member_phone:@event.member_phone[0...-1], member_approved:@event.member_approved[0...-1])
            if @event.member_phone.empty?
              @event.destroy
            end
            present @event
          end
        end

        desc "Member create  a event."
        post 'member_create' do
          @event = Event.new(params[:event])
          member_phone = params[:event][:member_phone] + current_member.phone + ";"
          if @event.update_attributes(member_phone:member_phone, member_approved:current_member.phone+";")
            present @event
          else
            error!({"error" => "创建日程失败。", "status" => "f" }, 400)
          end
        end

        desc "Coach approve the event"
        post 'coach_approve' do
          @event = Event.where("id = ? AND coach_id = ?  AND coach_approved = ?", params[:id], current_coach.id, false).first
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          elsif @event.update_attributes(coach_approved:true)
            present @event
          else
            error!({"error" => "该用户没有操作此日程权限。", "status" => "f" }, 400)
          end
        end

        desc "Coach refuse the event"
        post 'coach_refuse' do
          @event = Event.where("id = ? AND coach_id = ?  AND coach_approved = ?", params[:id], current_coach.id, false).first
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          elsif @event.update_attributes(coach_approved:false, coach_id:nil)
            present @event
          else
            error!({"error" => "该用户没有操作此日程权限。", "status" => "f" }, 400)
          end
        end

        desc "Coach get all waiting events"
        get 'coach_waiting_events' do
          @events = Event.where("coach_id = ? AND  coach_approved = ?", current_coach.id, false)
        end

        desc "Coach get all approved events"
        get 'coach_approved_events' do
          @events = Event.where("coach_id = ? AND  coach_approved = ?", current_coach.id, true)
        end

        desc "Get a event infomation"
        get ':id' do
          @event = Event.find_by_id(params[:id])
          if !@event.nil?
            present @event
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end


      end
    end
  end
end