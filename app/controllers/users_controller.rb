class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    # *Rails 4.0: 'strong parameters' in control layer replace 'attr_accessible' in the model layer*
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user         # user_url is not necessary.  @user will direct to the show page
    else
      render 'new'
    end
  end

  private
    # 'strong parameters' allow us to specify which parameters are required and which are permitted
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
