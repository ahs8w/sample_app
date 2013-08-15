module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token               # create a new token
    cookies.permanent[:remember_token] = remember_token    # place unencrypted token in browser cookies (cookies utility)
      # cookies[:remember_token] = { value: remember_token, expires: 20.years.from_now.utc }
    user.update_attribute(:remember_token, User.encrypt(remember_token))    # save encrypted token to database
    self.current_user = user                               # set current_user equal to given user
  end                                                      # uses the 'current_user=' function defined below

  def signed_in?
    !current_user.nil?        # a user is signed_in if current_user is not nil
  end

  def current_user=(user)      # assignment method for setting current_user
    @current_user = user
  end

  def current_user             # finding current user using the remember_token
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)      # '||=' or equals assignment operator
      # sets @current_user to the user corresponding to the remember_token but only if @current_user is undefined
      # calls 'find_by' method the first time 'current_user' is called but returns '@current_user' on later invocations

      # '||=' : similar to x += 1 -> increments variable : @user = @user || "user" -> sets value if it hasn't been set
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    self.current_user = nil       # not explicitly necessary but good to have if we want to sign_out w/out a redirect
    cookies.delete(:remember_token)
  end

## Friendly Forwarding ##
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end

# HTTP is a stateless protocol so web apps requiring signin must implement a way to track a user's progress 
# from page to page.  One technique is to use a Rails session (via 'session' function) to store a 'remember_token'
# equal to the user's id.  This allows the user_id to be available from page to page by storing it in a cookie
# that expires upon browser close.  
#     User.find(session[:remember_token]) -> works and is secure b/c of a 'session_id' generated each session
# Our application wants persistent sessions: sessions that last after the browser is closed.  We need a permanent
# identifier for a signed_in user.  We will generate a permanent 'remember_token' for each user and store it permanently.
# We will add it as an attribute to the User model.