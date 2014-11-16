module SessionsHelper
  def sign_in(admin)
    if params[:remember_me]
      cookies.permanent[:remember_token] = admin.remember_token
    else
      cookies[:remember_token] = admin.remember_token
    end
    self.current_admin = admin
  end

  def signed_in?
    !current_admin.nil?
  end

  def current_admin=(admin)
    @current_admin = admin
  end

  def current_admin
    @current_admin ||= Administrator.find_by_remember_token(cookies[:remember_token])
  end

  def current_admin?(admin)
    admin == current_admin
  end

  def sign_out
    self.current_admin = nil
    cookies.delete(:remember_token)
  end


  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end
