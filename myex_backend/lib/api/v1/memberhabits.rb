#encoding: utf-8

module API
  module V1
    class Memberhabits < Grape::API
      version 'v1'
      format :json

      resource :memberhabits do

        before do
          authenticate!
        end

        desc "Get member habit table."
        get ':id/habit' do
          @habit = MemberHabit.find_by_member_id(params[:id])
          if !@habit
            error!({"error" => "该会员生活健康习惯表不存在。", "status" => "f" }, 400)
          else
            present @habit
          end
        end
        
        desc "Create  member habit table."
        post 'create' do
          @habit = MemberHabit.new(params[:habit])
          if !MemberHabit.find_by_member_id(current_member.id).nil?
            error!({"error" => "该会员已创建生活健康习惯表。", "status" => "f" }, 400)
          elsif @habit.save && @habit.update_attributes(member_id:current_member.id)
            present @habit
          else
            error!({"error" => "创建生活健康习惯表失败。", "status" => "f" }, 400)
          end
        end

        desc "Update  member habit table."
        post 'update' do
          @habit = MemberHabit.find_by_member_id(current_member.id)
          if !@habit
            error!({"error" => "该会员生活健康习惯表不存在。", "status" => "f" }, 400)
          elsif @habit.update_attributes(params[:habit].except(:member_id))
            present @habit
          else
            error!({"error" => "修改生活健康习惯表失败。", "status" => "f" }, 400)
          end
        end

        desc "Delete  member habit table."
        post 'delete' do
          @habit = MemberHabit.find_by_member_id(current_member.id)
          if !@habit
            error!({"error" => "该会员生活健康习惯表不存在。", "status" => "f" }, 400)
          elsif @habit.delete
            present @habit
          else
            error!({"error" => "删除生活健康习惯表失败。", "status" => "f" }, 400)
          end
        end

        desc "Get  member habit table and assessment table."
        post 'both_tables' do
          @habit = MemberHabit.find_by_member_id(params[:member_id])
          @assessment = Assessment.find_by_id(params[:assessment_id])
          if !@habit || !@assessment
            error!({"error" => "参数错误。", "status" => "f" }, 400)
          else
            present [@habit, @assessment]
          end
        end

      end
    end
  end
end