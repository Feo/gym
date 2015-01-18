#encoding: utf-8
require 'net/http'
require 'digest/md5'
require 'pry'

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
          if @event.update_attributes(coach_id:current_coach.id, coach_approved:true, submitter:current_coach.phone, photo_url:current_coach.photo_url, nickname:current_coach.nickname)
            if @event.whether_weekly
              if params[:event][:monday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND monday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:monday]).count > 1
                @conflict = true
              elsif params[:event][:tuesday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND tuesday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:tuesday]).count > 1
                @conflict = true
              elsif params[:event][:wednesday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND wednesday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:wednesday]).count > 1
                @conflict = true
              elsif params[:event][:thursday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND thursday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:thursday]).count > 1
                @conflict = true
              elsif params[:event][:friday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND friday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:friday]).count > 1
                @conflict = true
              elsif params[:event][:saturday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND saturday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:saturday]).count > 1
                @conflict = true
              elsif params[:event][:sunday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND sunday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:sunday]).count > 1
                @conflict = true
              end
            elsif !@event.whether_weekly && Event.where("date = ? AND time = ? AND coach_id = ?", @event.date, @event.time, current_coach.id).count > 1
              @conflict = true
            end
            sendno = Time.now.to_i
            receiver_value = params[:event][:member_phone].gsub(/;/, ',')
            input = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value.to_s + I18n.t('.jpush.config.master_secret_member').to_s
            md5 = Digest::MD5.hexdigest(input)
            send_description = "创建新日程"
            n_content = "教练：#{current_coach.name}，手机号：#{current_coach.phone}，创建新日程。"
            n_extras = Hash[:type => "日程"]
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
              if @event.monday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND monday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", true).count > 1
                @conflict = true
              elsif @event.tuesday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND tuesday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", true).count > 1
                @conflict = true
              elsif @event.wednesday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND wednesday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", true).count > 1
                @conflict = true
              elsif @event.thursday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND thursday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", true).count > 1
                @conflict = true
              elsif @event.friday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND friday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", true).count > 1
                @conflict = true
              elsif @event.saturday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND saturday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", true).count > 1
                @conflict = true
              elsif @event.sunday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND sunday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", true).count > 1
                @conflict = true
              end
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
        post 'member_waiting_events' do
          var = current_member.phone
          @events1 = Event.where("member_phone like ? AND member_approved not like ? AND begin_date <= ? AND end_date >= ? AND whether_weekly = ?", "%#{var}%", "%#{var}%", params[:begin_date], params[:end_date], true)
          @events2 = Event.where("member_phone like ? AND member_approved not like ? AND date >= ? AND date <= ?", "%#{var}%", "%#{var}%", params[:begin_date], params[:end_date])
          @events = Event.from("(#{@events1.to_sql} union #{@events2.to_sql}) as events").order("week ASC").paginate(:page => params[:page], :per_page => params[:per_page])
          present [@events, :page => params[:page], :total_pages => @events.total_pages]
        end

        desc "Member get all approved events"
        post 'member_approved_events' do
          var = current_member.phone
          @events1 = Event.where("member_phone like ? AND member_approved like ? AND begin_date <= ? AND end_date >= ? AND whether_weekly = ?", "%#{var}%", "%#{var}%", params[:begin_date], params[:end_date], true)
          @events2 = Event.where("member_phone like ? AND member_approved like ? AND date >= ? AND date <= ?", "%#{var}%", "%#{var}%", params[:begin_date], params[:end_date])
          @events = Event.from("(#{@events1.to_sql} union #{@events2.to_sql}) as events").order("week ASC").paginate(:page => params[:page], :per_page => params[:per_page])
          present [@events, :page => params[:page], :total_pages => @events.total_pages]
        end

        desc "Member get all events"
        post 'member_all_events' do
          var = current_member.phone
          @events1 = Event.where("member_phone like ? AND begin_date <= ? AND end_date >= ? AND whether_weekly = ?", "%#{var}%", params[:begin_date], params[:end_date], true)
          @events2 = Event.where("member_phone like ? AND date >= ? AND date <= ?", "%#{var}%", params[:begin_date], params[:end_date])
          @events = Event.from("(#{@events1.to_sql} union #{@events2.to_sql}) as events").order("week ASC").paginate(:page => params[:page], :per_page => params[:per_page])
          present [@events, :page => params[:page], :total_pages => @events.total_pages]
        end

        desc "Coach update  a event."
        post 'coach_update' do
          @event = Event.where("coach_id = ? AND id = ?", current_coach.id, params[:id]).first
          @conflict = false
          if @event.nil?
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          elsif @event.update_attributes(params[:event])
            if @event.whether_weekly
              if params[:event][:monday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND monday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:monday]).count > 1
                @conflict = true
              elsif params[:event][:tuesday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND tuesday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:tuesday]).count > 1
                @conflict = true
              elsif params[:event][:wednesday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND wednesday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:wednesday]).count > 1
                @conflict = true
              elsif params[:event][:thursday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND thursday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:thursday]).count > 1
                @conflict = true
              elsif params[:event][:friday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND friday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:friday]).count > 1
                @conflict = true
              elsif params[:event][:saturday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND saturday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:saturday]).count > 1
                @conflict = true
              elsif params[:event][:sunday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND sunday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, params[:event][:sunday]).count > 1
                @conflict = true
              end
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
              if params[:event][:monday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND monday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:monday]).count > 1
                @conflict = true
              elsif params[:event][:tuesday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND tuesday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:tuesday]).count > 1
                @conflict = true
              elsif params[:event][:wednesday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND wednesday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:wednesday]).count > 1
                @conflict = true
              elsif params[:event][:thursday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND thursday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:thursday]).count > 1
                @conflict = true
              elsif params[:event][:friday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND friday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:friday]).count > 1
                @conflict = true
              elsif params[:event][:saturday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND saturday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:saturday]).count > 1
                @conflict = true
              elsif params[:event][:sunday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND sunday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:sunday]).count > 1
                @conflict = true
              end
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
          if @event.update_attributes(member_phone:member_phone, member_approved:current_member.phone+";", submitter:current_member.phone, photo_url:current_member.photo_url, nickname:current_member.nickname)
            if @event.whether_weekly
              if params[:event][:monday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND monday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:monday]).count > 1
                @conflict = true
              elsif params[:event][:tuesday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND tuesday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:tuesday]).count > 1
                @conflict = true
              elsif params[:event][:wednesday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND wednesday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:wednesday]).count > 1
                @conflict = true
              elsif params[:event][:thursday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND thursday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:thursday]).count > 1
                @conflict = true
              elsif params[:event][:friday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND friday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:friday]).count > 1
                @conflict = true
              elsif params[:event][:saturday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND saturday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:saturday]).count > 1
                @conflict = true
              elsif params[:event][:sunday] && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND member_approved like ? AND sunday = ?",true, @event.time, @event.end_date, @event.begin_date, "%#{phone}%", params[:event][:sunday]).count > 1
                @conflict = true
              end
            elsif !@event.whether_weekly && Event.where("date = ? AND time = ? AND member_approved like ?", @event.date, @event.time, "%#{phone}%").count > 1
              @conflict = true
            end
            @coach = Coach.find_by_id(params[:event][:coach_id])
            if @coach
              sendno = Time.now.to_i
              receiver_value = @coach.phone.to_s
              input = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value.to_s + I18n.t('.jpush.config.master_secret_coach').to_s
              md5 = Digest::MD5.hexdigest(input)
              send_description = "创建新日程"
              n_content = "会员：#{current_member.name}，手机号：#{current_member.phone}，创建新日程。"
              n_extras = Hash[:type => "日程"]
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
            end
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
              if @event.monday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND monday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, true).count > 1
                @conflict = true
              elsif @event.tuesday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND tuesday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, true).count > 1
                @conflict = true
              elsif @event.wednesday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND wednesday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, true).count > 1
                @conflict = true
              elsif @event.thursday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND thursday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, true).count > 1
                @conflict = true
              elsif @event.friday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND friday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, true).count > 1
                @conflict = true
              elsif @event.saturday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND saturday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, true).count > 1
                @conflict = true
              elsif @event.sunday && Event.where("whether_weekly = ? AND time = ? and not begin_date >= ? and not end_date <= ? AND coach_id = ? AND sunday = ?",true, @event.time, @event.end_date, @event.begin_date, current_coach.id, true).count > 1
                @conflict = true
              end
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
        post 'coach_waiting_events' do
          @events1 = Event.where("coach_id = ? AND  coach_approved = ? AND date >= ? AND date <= ?", current_coach.id, false, params[:begin_date], params[:end_date])
          @events2 = Event.where("coach_id = ? AND  coach_approved = ? AND begin_date <= ? AND end_date >= ? AND whether_weekly = ?", current_coach.id, false, params[:begin_date], params[:end_date], true)
          @events = Event.from("(#{@events1.to_sql} union #{@events2.to_sql}) as events").order("week ASC").paginate(:page => params[:page], :per_page => params[:per_page])
          present [@events, :page => params[:page], :total_pages => @events.total_pages]
        end

        desc "Coach get all approved events"
        post 'coach_approved_events' do
          @events1 = Event.where("coach_id = ? AND  coach_approved = ? AND begin_date <= ? AND end_date >= ? AND whether_weekly = ?", current_coach.id, true, params[:begin_date], params[:end_date], true)
          @events2 = Event.where("coach_id = ? AND  coach_approved = ? AND date >= ? AND date <= ?", current_coach.id, true, params[:begin_date], params[:end_date])
          @events = Event.from("(#{@events1.to_sql} union #{@events2.to_sql}) as events").order("week ASC").paginate(:page => params[:page], :per_page => params[:per_page])
          present [@events, :page => params[:page], :total_pages => @events.total_pages]
        end

        desc "Coach get all events"
        post 'coach_all_events' do
          @events1 = Event.where("coach_id = ? AND begin_date <= ? AND end_date >= ? AND whether_weekly = ?", current_coach.id, params[:begin_date], params[:end_date], true)
          @events2 = Event.where("coach_id = ? AND date >= ? AND date <= ?", current_coach.id, params[:begin_date], params[:end_date])
          @events = Event.from("(#{@events1.to_sql} union #{@events2.to_sql}) as events").order("week ASC").paginate(:page => params[:page], :per_page => params[:per_page])
          present [@events, :page => params[:page], :total_pages => @events.total_pages]
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