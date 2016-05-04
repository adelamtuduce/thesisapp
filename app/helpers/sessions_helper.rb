module SessionsHelper
  def sign_in(user)
    puts "OOOOOOOOOOOOOOOOOOOOOOOOO"
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.my_current_user = user
  end

  def signed_in?
    !my_current_user.nil?
  end

  def my_current_user=(user)
    @my_current_user = user
  end

  def my_current_user
    remember_token  = User.digest(cookies[:remember_token])
    @my_current_user ||= User.find_by(remember_token: remember_token)
  end

  def my_current_user?(user)
    user == my_current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    my_current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.my_current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end