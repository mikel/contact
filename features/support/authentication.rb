module AuthenticationHelpers
  # Provides basic authentication helpers for logging in and out
  
  def login_user(params = [])
    params = [params] unless params.respond_to?(:each)
    user = Factory(:user)
    params.each do |param|
      send(param, user)
    end
    user
  end
  
  def make_administrator(user)
    role = Factory(:admin_role)
    user.admin = true
  end

end

World(AuthenticationHelpers)
