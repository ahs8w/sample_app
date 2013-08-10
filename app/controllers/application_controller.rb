class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  # by default all helpers are available in views (but not in controllers).  We need methods from sessions helper in both
  # views and controllers so we must include it explicitly
end
