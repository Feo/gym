module API
  module V1
    class Members < Grape::API
      version 'v1'
      format :json

      resource :members do
        desc "Register a new member"
        post 'register' do
          @member = Member.new(params[:member])
          if !Member.find_by_email(params[:member][:email]).nil?
            error!({"error" => "该邮箱已被使用，请重新输入。" }, 400)
          elsif @member.save
            sign_in_member @member
            present @member
          else
            error!({"error" => "注册失败。" }, 400)
          end
        end

        desc "Member login"
        post 'login' do
          @member = Member.find_by_email(params[:session][:email].downcase)
          if params[:session][:password] != params[:session][:password_confirmation]
            error!({"error" => "邮箱或密码错误。" }, 400)
          elsif @member && @member.authenticate(params[:session][:password])
            sign_in_member @member
            present @member
          else
            error!({"error" => "邮箱或密码错误。" }, 400)
          end
        end

        before do
          authenticate_member!
        end

        desc "Member logout"
        post 'logout' do
          @member = self.current_member
          self.current_member = nil
          cookies[:remember_token] = nil
          present @member
        end

        desc "Update member information"
        post 'update' do
          @member = current_member
          if params[:member][:password] != params[:member][:password_confirmation]
            error!({"error" => "确认密码错误。" }, 400)
          elsif @member.update_attributes(params[:member])
            sign_in_member @member
            present @member
          else
            error!({"error" => "修改会员信息不成功。" }, 400)
          end
        end

        desc "Get current member information"
        get 'info' do
          present current_member
        end

        desc "Get certain member information with id"
        get ':id/info' do
          @member = Member.find_by_id(params[:id])
          if @member
            present @member
          else
            error!({"error" => "ID错误。" }, 400)
          end
        end

        desc "Find coaches information"
        post 'find_coach' do
          age_less = params[:coach][:age_less] || ""
          if age_less.empty?
            age_less = 100
          end
          experience_less = params[:coach][:experience_less] || ""
          if experience_less.empty?
            experience_less = 100
          end
          grade_less = params[:coach][:grade_less] || ""
          if grade_less.empty?
            grade_less = 100
          end
          @coaches = Coach.where("nickname like ?
                                                    AND name like ?
                                                    AND province like ?
                                                    AND city like ?
                                                    AND district like ?
                                                    AND street like ?
                                                    AND email like ?
                                                    AND gender like ?
                                                    AND profession like ?
                                                    AND organization like ?
                                                    AND age >= ?
                                                    AND age <= ?
                                                    AND experience >= ?
                                                    AND experience <= ?
                                                    AND grade >= ?
                                                    AND grade <= ?",
                                                    "%#{params[:coach][:nickname]}%",
                                                    "%#{params[:coach][:name]}%",
                                                    "%#{params[:coach][:province]}%",
                                                   "%#{params[:coach][:city]}%",
                                                   "%#{params[:coach][:district]}%",
                                                   "%#{params[:coach][:street]}%",
                                                   "%#{params[:coach][:email]}%",
                                                   "%#{params[:coach][:gender]}%",
                                                   "%#{params[:coach][:profession]}%",
                                                   "%#{params[:coach][:organization]}%",
                                                   "#{params[:coach][:age_greater]}",
                                                   age_less,
                                                   "#{params[:coach][:experience_greater]}",
                                                   experience_less,
                                                   "#{params[:coach][:grade_greater]}",
                                                   grade_less)
          present @coaches
        end

        desc "Apply a private coach"
        post 'apply_coach' do
          @coach = Coach.find_by_id(params[:id])
          @member = current_member
          if @member.have_coach
            error!({"error" => "会员已有私教。" }, 400)
          elsif @coach
            @member.update_attributes(coach_id:params[:id])
            sign_in_member @member
            present @member
          else
            error!({"error" => "教练ID错误。" }, 400)
          end
        end

        desc "Delete the current private coach"
        post 'delete_coach' do
          @member = current_member
          if !@member.have_coach
            error!({"error" => "会员没有关联的私教。" }, 400)
          else
            @member.update_attributes(coach_id:nil, have_coach:false, grade:nil, grade_time:nil)
            sign_in_member @member
            present @member
          end
        end

        desc "Get the current private coach information"
        get 'coach_info' do
          @member = current_member
          if @member.have_coach
            @coach = Coach.find_by_id(@member.coach_id)
            present @coach
          else
            error!({"error" => "会员没有关联的私教。" }, 400)
          end
        end

        desc "Grading the current private coach"
        post 'grade_coach' do
          @member = current_member
          if !@member.have_coach
            error!({"error" => "会员没有关联的私教。" }, 400)
          elsif @member.grade_time && Time.now - @member.grade_time < 1.month
            error!({"error" => "一个月内只能修改一次。" }, 400)
          else
            @member.update_attributes(grade:params[:grade], grade_time:Time.now)
            @members = Member.where("have_coach = ? AND coach_id = ? AND grade is not null", true, @member.coach_id)
            total_grade = 0
            @members.each do |member|
              total_grade = total_grade + member.grade
            end
            @coach = Coach.find_by_id(@member.coach_id)
            @coach.update_attributes(grade:((total_grade/@members.count).round(1)))
            sign_in_member @member
            present [@member, @coach]
          end
        end

      end
    end
  end
end