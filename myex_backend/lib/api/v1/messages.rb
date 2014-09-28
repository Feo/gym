#encoding: utf-8

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
          if @message.save
            present @message
          else
            error!({"error" => "创建消息失败。", "status" => "f" }, 400)
          end
        end

        desc "Update a message."
        post 'update' do
          @message = Message.find_by_id(params[:id])
          if @message && @message.update_attributes(params[:message])
            present @message
          else
            error!({"error" => "更新消息失败。", "status" => "f" }, 400)
          end
        end

        
        desc "Delete a message."
        post 'delete' do
          @message = Message.find_by_id(params[:id])
          if @message
            @message.destroy
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

        desc "Get a coach's all message with a member."
        post 'all_message' do
          if !params[:coach_phone].empty? && !params[:member_phone].empty?
            @messages = Message.where("coach_phone like ? AND member_phone like ?", "%#{params[:coach_phone]}%", "%#{params[:member_phone]}%")
          else
            error!({"error" => "参数不能为空。", "status" => "f" }, 400)
          end
        end

        desc "Delete a coach's all message with a member."
        post 'delete_all_message' do
          if !params[:coach_phone].empty? && !params[:member_phone].empty?
            @messages = Message.where("coach_phone like ? AND member_phone like ?", "%#{params[:coach_phone]}%", "%#{params[:member_phone]}%")
            @messages.each do |message|
              message.destroy
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