#encoding: utf-8

module API
  module V1
    class Records < Grape::API
      version 'v1'
      format :json

      resource :records do

        before do
          authenticate!
        end

        desc "Create a new record."
        post 'create' do
          if !current_coach.nil?
            submitter = current_coach.name
          elsif !current_member.nil?
            submitter = current_member.name
          end
          @record = Record.new(time:params[:time], submitter:submitter, template:false, member_id:params[:member_id])
          if @record.save
            flag = false
            if params[:actions].kind_of?(Array)
              params[:actions].each do |action|
                Action.create(kind:action[0], name:action[1], weight_or_duration:action[2], group_or_speed:action[3], time_or_rate:action[4], record_id:@record.id)
                flag = true
              end
            else
              @record.destroy
              error!({"error" => "[action]参数错误。", "status" => "f" }, 400)
            end
            @actions = Action.where("record_id = ?", @record.id)
            if flag
              present [@record, @actions]
            else
              @record.destroy
              error!({"error" => "创建记录失败。", "status" => "f" }, 400)
            end
          else
            error!({"error" => "创建记录失败。", "status" => "f" }, 400)
          end
        end

        desc "Delete a record and template."
        post 'delete' do
          @record = Record.find_by_id(params[:id])
          @actions = Action.where("record_id = ?", params[:id])
          if @record
            @record.destroy
            @actions.each do |action|
              action.destroy
            end
            present [@record, @actions]
          else
            error!({"error" => "删除记录失败。", "status" => "f" }, 400)
          end
        end

        desc "Create or update a template."
        post 'create_or_update_template' do
          @old_template = Record.where("template = ? AND member_id = ?", true, params[:member_id]).first
          if !@old_template.nil?
            @old_actions = Action.where("record_id = ?", @old_template.id)
            @old_template.destroy
            @old_actions.each do |action|
              action.destroy
            end
          end
          @template = Record.new(template:true, member_id:params[:member_id])
          if @template.save
            flag = false
            if params[:actions].kind_of?(Array)
              params[:actions].each do |action|
                Action.create(kind:action[0], name:action[1], weight_or_duration:action[2], group_or_speed:action[3], time_or_rate:action[4], record_id:@template.id)
                flag = true
              end
            else
              @template.destroy
              error!({"error" => "[action]参数错误。", "status" => "f" }, 400)
            end
            @actions = Action.where("record_id = ?", @template.id)
            if flag
              present [@template, @actions]
            else
              @template.destroy
              error!({"error" => "创建运动方案失败。", "status" => "f" }, 400)
            end
          else
            error!({"error" => "创建运动方案失败。", "status" => "f" }, 400)
          end
        end

        desc "Get all records."
        post 'all' do
          response = []
          @records = Record.where("template = ? AND member_id = ?", false, params[:id])
          @records.each do |record|
            @actions = Action.where("record_id = ?", record.id)
            response << [record, @actions]
          end
          present response
        end
        
        desc "Get the member's template."
        post 'template' do
          @template = Record.where("template = ? AND member_id = ?", true, params[:id]).first
          if !@template.nil?
            @actions = Action.where("record_id = ?", @template.id)
            present [@template, @actions]
          else
            error!({"error" => "该会员无模板。", "status" => "f" }, 400)
          end
        end

      end
    end
  end
end