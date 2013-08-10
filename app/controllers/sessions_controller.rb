class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # sign user in and redirect to show page
      sign_in user          # 'sign_in' function doesn't exist -> necessary to write it
      redirect_to user
    else
      flash.now[:error] = "Invalid email/password combination" # must put 'flash.now' to avoid flash persistance bug!!
      # flash messages persist for one request; a render doesn't count as a request; flash stays too long w/out '.now'
      render 'new'
    end
  end

  def destroy
  end
end
