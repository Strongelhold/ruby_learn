module UserHelper
  def login?
    if session[:email].nil?
      false
    else
      true
    end
  end
end

helpers UserHelper
