#encoding: utf-8

module API
  module V1
    class Assessments < Grape::API
      version 'v1'
      format :json

      resource :assessments do

        before do
          authenticate!
        end

        desc "Create a new assessment."
        post 'create' do
          if params[:assessment][:member_id].empty?
            error!({"error" => "参数[assessment][member_id]不能为空。", "status" => "f" }, 400)
          elsif !current_coach.nil?
            submitter = current_coach.name
          elsif !current_member.nil?
            submitter = current_member.name
          end
          @assessment = Assessment.new(params[:assessment])
          @old_assessment = Assessment.where("member_id = ?", params[:assessment][:member_id]).last
          if false #!@old_assessment.nil? && Time.now - @old_assessment.created_at < 2592000
            error!({"error" => "一个月内只能评估一次。", "status" => "f" }, 400)
          elsif @assessment.save && @assessment.update_attributes(submitter:submitter)
            present @assessment
          else
            error!({"error" => "创建评估失败。", "status" => "f" }, 400)
          end
        end

        desc "Update an assessment."
        post 'update' do
          @assessment = Assessment.find_by_id(params[:id])
          if @assessment && @assessment.update_attributes(params[:assessment])
            present @assessment
          else
            error!({"error" => "更新评估失败。", "status" => "f" }, 400)
          end
        end

        desc "Delete a assessment."
        post 'delete' do
          @assessment = Assessment.find_by_id(params[:id])
          if @assessment
            @assessment.destroy
            present @assessment
          else
            error!({"error" => "删除评估失败。", "status" => "f" }, 400)
          end
        end

        desc "Get all assessments."
        post 'all' do
          @assessments = Assessment.where("member_id = ?", params[:member_id])
          if @assessments
            present @assessments
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

        desc "Get a message."
        get ':id' do
          @assessment = Assessment.find_by_id(params[:id])
          if @assessment
            present @assessment
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

      end
    end
  end
end