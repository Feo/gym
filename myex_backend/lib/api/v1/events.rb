#encoding: utf-8
require 'net/http'
require 'digest/md5'

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
          @conflict = false
          if @event.update_attributes(coach_id:current_coach.id, coach_approved:true, submitter:current_coach.phone)
            if @event.whether_weekly
              @event.week.split(";").each do |week|
                if Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND week like ?  AND coach_id = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{week}%", current_coach.id).count > 1
                  @conflict = true
                end
              end
            elsif !@event.whether_weekly && !Event.where("week like ? AND time = ? AND begin_date <= ? AND end_date >= ? AND coach_id = ?", "%#{@event.day}%", @event.time, @event.date, @event.date, current_coach.id).empty?
              @conflict = true
            elsif !@event.whether_weekly && Event.where("date = ? AND time = ? AND coach_id = ?", @event.date, @event.time, current_coach.id).count > 1
              @conflict = true
            end
            sendno = Time.now.to_i
            receiver_value = params[:event][:member_phone].gsub(/;/, ',')
            input = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value.to_s + I18n.t('.jpush.config.master_secret_member').to_s
            md5 = Digest::MD5.hexdigest(input)
            send_description = "创建新日程"
            n_content = "教练：#{current_coach.name}，手机号：#{current_coach.phone}，创建新日程。"
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
            present [@event, "conflict" => @conflict]
          else
            error!({"error" => "创建日程失败。", "status" => "f" }, 400)
          end
        end

        desc "Member approve the event"
        post 'member_approve' do
          @event = Event.find_by_id(params[:id])
          @conflict = false
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          elsif @event.member_phone.to_s.include?(current_member.phone) && !@event.member_approved.to_s.include?(current_member.phone)
            member_approved = @event.member_approved.to_s + current_member.phone + ";"
            phone = current_member.phone + ";"
            @event.update_attributes(member_approved:member_approved)
            if @event.whether_weekly
              @event.week.split(";").each do |week|
                if Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND week like ?  AND member_approved like ?",true, @event.time, @event.end_date, @event.begin_date, "%#{week}%", "%#{phone}%").count > 1
                  @conflict = true
                end
              end
            elsif !@event.whether_weekly && !Event.where("week like ? AND time = ? AND begin_date <= ? AND end_date >= ? AND member_approved like ?", "%#{@event.day}%", @event.time, @event.date, @event.date, "%#{phone}%").empty?
              @conflict = true
            elsif !@event.whether_weekly && Event.where("date = ? AND time = ? AND member_approved like ?", @event.date, @event.time, "%#{phone}%").count > 1
              @conflict = true
            end
            present [@event, "conflict" => @conflict]
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

        desc "Member get all events"
        get 'member_all_events' do
          var = current_member.phone + ";"
          @events = Event.where("member_phone like ?", "%#{var}%")
        end

        desc "Coach update  a event."
        post 'coach_update' do
          @event = Event.where("coach_id = ? AND id = ?", current_coach.id, params[:id]).first
          @conflict = false
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          elsif @event.update_attributes(params[:event])
            if @event.whether_weekly
              @event.week.split(";").each do |week|
                if Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND week like ?  AND coach_id = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{week}%", current_coach.id).count > 1
                  @conflict = true
                end
              end
            elsif !@event.whether_weekly && !Event.where("week like ? AND time = ? AND begin_date <= ? AND end_date >= ? AND coach_id = ?", "%#{@event.day}%", @event.time, @event.date, @event.date, current_coach.id).empty?
              @conflict = true
            elsif !@event.whether_weekly && Event.where("date = ? AND time = ? AND coach_id = ?", @event.date, @event.time, current_coach.id).count > 1
              @conflict = true
            end
            present [@event, "conflict" => @conflict]
          else
            error!({"error" => "更新日程失败。", "status" => "f" }, 400)
          end
        end

        desc "Member update  a event."
        post 'member_update' do
          phone = current_member.phone + ";"
          @conflict = false
          @event = Event.where("member_phone like ? AND id = ?", "%#{phone}%", params[:id]).first
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          elsif @event.update_attributes(params[:event])
            member_phone = params[:event][:member_phone] + current_member.phone + ";"
            @event.update_attributes(member_phone:member_phone)
            if @event.whether_weekly
              @event.week.split(";").each do |week|
                if Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND week like ?  AND member_approved like ?",true, @event.time, @event.end_date, @event.begin_date, "%#{week}%", "%#{phone}%").count > 1
                  @conflict = true
                end
              end
            elsif !@event.whether_weekly && !Event.where("week like ? AND time = ? AND begin_date <= ? AND end_date >= ? AND member_approved like ?", "%#{@event.day}%", @event.time, @event.date, @event.date, "%#{phone}%").empty?
              @conflict = true
            elsif !@event.whether_weekly && Event.where("date = ? AND time = ? AND member_approved like ?", @event.date, @event.time, "%#{phone}%").count > 1
              @conflict = true
            end
            present [@event, "conflict" => @conflict]
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
          @conflict = false
          member_phone = params[:event][:member_phone] + current_member.phone + ";"
          phone = current_member.phone + ";"
          if @event.update_attributes(member_phone:member_phone, member_approved:current_member.phone+";", submitter:current_member.phone)
            if @event.whether_weekly
              @event.week.split(";").each do |week|
                if Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND week like ?  AND member_approved like ?",true, @event.time, @event.end_date, @event.begin_date, "%#{week}%", "%#{phone}%").count > 1
                  @conflict = true
                end
              end
            elsif !@event.whether_weekly && !Event.where("week like ? AND time = ? AND begin_date <= ? AND end_date >= ? AND member_approved like ?", "%#{@event.day}%", @event.time, @event.date, @event.date, "%#{phone}%").empty?
              @conflict = true
            elsif !@event.whether_weekly && Event.where("date = ? AND time = ? AND member_approved like ?", @event.date, @event.time, "%#{phone}%").count > 1
              @conflict = true
            end
            @coach = Coach.find_by_id(params[:event][:coach_id])
            sendno = Time.now.to_i
            receiver_value = @coach.phone.to_s
            input = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value.to_s + I18n.t('.jpush.config.master_secret_coach').to_s
            md5 = Digest::MD5.hexdigest(input)
            send_description = "创建新日程"
            n_content = "会员：#{current_member.name}，手机号：#{current_member.phone}，创建新日程。"
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
            present [@event, "conflict" => @conflict]
          else
            error!({"error" => "创建日程失败。", "status" => "f" }, 400)
          end
        end

        desc "Coach approve the event"
        post 'coach_approve' do
          @event = Event.where("id = ? AND coach_id = ?  AND coach_approved = ?", params[:id], current_coach.id, false).first
          @conflict = false
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          elsif @event.update_attributes(coach_approved:true)
            if @event.whether_weekly
              @event.week.split(";").each do |week|
                if Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND week like ?  AND coach_id = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{week}%", current_coach.id).count > 1
                  @conflict = true
                end
              end
            elsif !@event.whether_weekly && !Event.where("week like ? AND time = ? AND begin_date <= ? AND end_date >= ? AND coach_id = ?", "%#{@event.day}%", @event.time, @event.date, @event.date, current_coach.id).empty?
              @conflict = true
            elsif !@event.whether_weekly && Event.where("date = ? AND time = ? AND coach_id = ?", @event.date, @event.time, current_coach.id).count > 1
              @conflict = true
            end
            present [@event, "conflict" => @conflict]
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

        desc "Coach get all events"
        get 'coach_all_events' do
          @events = Event.where("coach_id = ?", current_coach.id)
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