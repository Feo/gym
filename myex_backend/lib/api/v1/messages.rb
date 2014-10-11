#encoding: utf-8
require 'net/http'
require 'digest/md5'

module API
  module V1
    class Messages < Grape::API
      version 'v1'
      format :json

      resource :messages do

        before do
          authenticate!
        end

        desc "Create a new message."
        post 'create' do
          @message = Message.new(params[:message])
          @message.update_attributes(member_phone_array:params[:message][:member_phone], coach_phone_array:params[:message][:coach_phone])
          if @message.save
            sendno = Time.now.to_i
            receiver_value_coach = params[:message][:coach_phone].gsub(/;/, ',')
            input_coach = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value_coach.to_s + I18n.t('.jpush.config.master_secret_coach').to_s
            md5_coach = Digest::MD5.hexdigest(input_coach)
            send_description = "创建新消息"
            n_content = "新消息：#{params[:message][:content]}"
            msg_content = Hash[:n_content => n_content].to_json
            output_coach = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                            :sendno => sendno,
                                                            :app_key => I18n.t('.jpush.config.app_key_coach'),
                                                            :receiver_type => I18n.t('.jpush.config.receiver_type'),
                                                            :receiver_value => receiver_value_coach,
                                                            :verification_code => md5_coach,
                                                            :msg_type => I18n.t('.jpush.config.msg_type'),
                                                            :msg_content => msg_content,
                                                            :send_description => send_description,
                                                            :time_to_live => I18n.t('.jpush.config.time_to_live'),
                                                            :platform => I18n.t('.jpush.config.platform'))
            receiver_value_member = params[:message][:member_phone].gsub(/;/, ',')
            input_member = sendno.to_s + I18n.t('.jpush.config.receiver_type').to_s + receiver_value_member.to_s + I18n.t('.jpush.config.master_secret_member').to_s
            md5_member = Digest::MD5.hexdigest(input_member)
            msg_content = Hash[:n_content => n_content].to_json
            output_member = Net::HTTP.post_form(URI.parse(I18n.t('.jpush.config.uri')),
                                                            :sendno => sendno,
                                                            :app_key => I18n.t('.jpush.config.app_key_member'),
                                                            :receiver_type => I18n.t('.jpush.config.receiver_type'),
                                                            :receiver_value => receiver_value_member,
                                                            :verification_code => md5_member,
                                                            :msg_type => I18n.t('.jpush.config.msg_type'),
                                                            :msg_content => msg_content,
                                                            :send_description => send_description,
                                                            :time_to_live => I18n.t('.jpush.config.time_to_live'),
                                                            :platform => I18n.t('.jpush.config.platform'))
            present @message
          else
            error!({"error" => "创建消息失败。", "status" => "f" }, 400)
          end
        end

        desc "Update a message."
        post 'update' do
          @message = Message.find_by_id(params[:id])
          if @message && @message.update_attributes(params[:message])
            @message.update_attributes(member_phone_array:params[:message][:member_phone], coach_phone_array:params[:message][:coach_phone])
            present @message
          else
            error!({"error" => "更新消息失败。", "status" => "f" }, 400)
          end
        end

        
        desc "Coach delete a message."
        post 'coach_delete' do
          @message = Message.find_by_id(params[:id])
          if @message
            var = current_coach.phone + ";"
            coach_phone = @message.coach_phone
            coach_phone.slice!(/#{var}/)
            @message.update_attributes(coach_phone:coach_phone + ";")
            @message.update_attributes(coach_phone:@message.coach_phone[0...-1])
            present @message
          else
            error!({"error" => "删除消息失败。", "status" => "f" }, 400)
          end
        end

        desc "Member delete a message."
        post 'member_delete' do
          @message = Message.find_by_id(params[:id])
          if @message
            var = current_member.phone + ";"
            member_phone = @message.member_phone
            member_phone.slice!(/#{var}/)
            @message.update_attributes(member_phone:member_phone + ";")
            @message.update_attributes(member_phone:@message.member_phone[0...-1])
            present @message
          else
            error!({"error" => "删除消息失败。", "status" => "f" }, 400)
          end
        end

        desc "Get a coach's all message."
        get 'coach_message' do
          @messages = Message.where("coach_phone like ?", "%#{current_coach.phone}%")
        end

        desc "Get a member's all message."
        get 'member_message' do
          @messages = Message.where("member_phone like ?", "%#{current_member.phone}%")
        end

        desc "Get current coach's all message with a member."
        post 'coach_member_messages' do
          if !params[:member_phone].empty?
            @messages = Message.where("coach_phone like ? AND member_phone_array like ?", "%#{current_coach.phone}%", "%#{params[:member_phone]}%")
          else
            error!({"error" => "参数不能为空。", "status" => "f" }, 400)
          end
        end

        desc "Get current member's all message with a coach."
        post 'member_coach_messages' do
          if !params[:coach_phone].empty?
            @messages = Message.where("coach_phone_array like ? AND member_phone like ?", "%#{params[:coach_phone]}%", "%#{current_member.phone}%")
          else
            error!({"error" => "参数不能为空。", "status" => "f" }, 400)
          end
        end

        desc "Coach delete all messages with a member."
        post 'coach_delete_all' do
          if !params[:member_phone].empty?
            @messages = Message.where("coach_phone like ? AND member_phone_array like ?", "%#{current_coach.phone}%", "%#{params[:member_phone]}%")
            var = current_coach.phone + ";"
            @messages.each do |message|
              coach_phone = message.coach_phone
              coach_phone.slice!(/#{var}/)
              message.update_attributes(coach_phone:coach_phone + ";")
              message.update_attributes(coach_phone:message.coach_phone[0...-1])
            end
            present @messages
          else
            error!({"error" => "参数不能为空。", "status" => "f" }, 400)
          end
        end

        desc "Member delete all message with a coach."
        post 'member_delete_all' do
          if !params[:coach_phone].empty?
            @messages = Message.where("coach_phone_array like ? AND member_phone like ?", "%#{params[:coach_phone]}%", "%#{current_member.phone}%")
            var = current_member.phone + ";"
            @messages.each do |message|
              member_phone = message.member_phone
              member_phone.slice!(/#{var}/)
              message.update_attributes(member_phone:member_phone + ";")
              message.update_attributes(member_phone:message.member_phone[0...-1])
            end
            present @messages
          else
            error!({"error" => "参数不能为空。", "status" => "f" }, 400)
          end
        end

        desc "Get a message."
        get ':id' do
          @message = Message.find_by_id(params[:id])
          if @message
            present @message
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

      end
    end
  end
end