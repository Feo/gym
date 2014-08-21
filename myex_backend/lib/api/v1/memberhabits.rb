module API
  module V1
    class Memberhabits < Grape::API
      version 'v1'
      format :json

      resource :memberhabits do

        before do
          authenticate_member!
        end
        
        desc "Create  member habit table."
        post 'create' do
          @habit = MemberHabit.new(params[:habit])
          if !params[:habit][:member_id].empty? && !MemberHabit.find_by_member_id(params[:habit][:member_id]).nil?
            error!({"error" => "该会员已创建生活健康习惯表。", "status" => "f" }, 400)
          elsif @habit.save
            present @habit
          else
            error!({"error" => "创建生活健康习惯表失败。", "status" => "f" }, 400)
          end
        end

        desc "Update  member habit table."
        post 'update' do
          @habit = MemberHabit.find_by_member_id(params[:habit][:member_id])
          if !@habit
            error!({"error" => "改会员生活健康习惯表不存在。", "status" => "f" }, 400)
          elsif @habit.update_attributes(params[:habit])
            present @habit
          else
            error!({"error" => "修改生活健康习惯表失败。", "status" => "f" }, 400)
          end
        end

        desc "Delete  member habit table."
        post 'delete' do
          @habit = MemberHabit.find_by_member_id(params[:habit][:member_id])
          if !@habit
            error!({"error" => "改会员生活健康习惯表不存在。", "status" => "f" }, 400)
          elsif @habit.delete
            present @habit
          else
            error!({"error" => "删除生活健康习惯表失败。", "status" => "f" }, 400)
          end
        end

      end
    end
  end
end