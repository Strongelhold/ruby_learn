module UserHelper
  def login?
    if session[:email].nil?
      false
    else
      true
    end
  end

  def current_user
    return User.first(session[:email])
  end
end

helpers UserHelper
