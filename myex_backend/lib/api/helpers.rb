#encoding: utf-8

module API
  module APIHelpers
    def current_coach
      @current_coach ||= Coach.find_by_remember_token(cookies[:remember_token])
    end

    def sign_in_coach(coach)
      if params[:remember_me]
        cookies.permanent[:remember_token] = coach.remember_token
      else
        cookies[:remember_token] = coach.remember_token
      end
      self.current_coach = coach
    end

    def current_coach=(coach)
      @current_coach = coach
    end

    def authenticate_coach!
      error!('未登录。', 401) unless current_coach
    end

    def current_member
      @current_member ||= Member.find_by_remember_token(cookies[:remember_token])
    end

    def sign_in_member(member)
      if params[:remember_me]
        cookies.permanent[:remember_token] = member.remember_token
      else
        cookies[:remember_token] = member.remember_token
      end
      self.current_member = member
    end

    def current_member=(member)
      @current_member = member
    end

    def authenticate_member!
      error!('未登录。', 401) unless current_member
    end


    def authenticate!
      error!('未登录。', 401) unless (current_member || current_coach)
    end
  end
end