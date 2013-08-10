module SessionsHelper
end

# HTTP is a stateless protocol so web apps requiring signin must implement a way to track a user's progress 
# from page to page.  One technique is to use a Rails session (via 'session' function) to store a 'remember_token'
# equal to the user's id.  This allows the user_id to be available from page to page by storing it in a cookie
# that expires upon browser close.  
#     User.find(session[:remember_token]) -> works and is secure b/c of a 'session_id' generated each session
# Our application wants persistent sessions: sessions that last after the browser is closed.  We need a permanent
# identifier for a signed_in user.  We will generate a permanent 'remember_token' for each user and store it permanently.
# We will add it as an attribute to the User model.