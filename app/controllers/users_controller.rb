class UsersController < ApplicationController
  before_action :signed_in_user,    only: [:index, :edit, :update]
  before_action :correct_user,      only: [:edit, :update]
  before_action :admin_user,        only: :destroy
  before_action :already_signed_in, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    # @user = User.find(params[:id])   ->  replaced by before filters
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

  def update
    # @user = User.find(params[:id])   ->  replaced by before filters
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if !@user.admin?
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    else
      redirect_to root_url
    end
  end

  private
    # 'strong parameters' allow us to specify which parameters are required and which are permitted
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    def already_signed_in
      unless !signed_in?
        redirect_to root_url, notice: "You are already signed up."
      end
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."             # flash[:notice] = ""
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
