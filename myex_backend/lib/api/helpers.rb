module API
  module APIHelpers
    def current_coach
      @current_coach ||= Coach.find_by_remember_token(cookies[:remember_token])
    end

    def authenticate!
      error!('未登录。', 401) unless current_coach
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
  end
end