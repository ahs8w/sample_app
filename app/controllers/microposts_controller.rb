class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])  
      redirect_to root_url if @micropost.nil?
    end
        # find_by instead of find b/c find raises an exception when micropost doesn't exist instead of returning 'nil'
        # good practice to always run lookups through the association rather than:  Micropost.find_by(id: params[:id])
          # illustrates the difference btw authentication and authorization: an authenticated user(one already signed in) 
          # could change the address (thus changing the id parameter) and access a different user's account.
        # could also be written like this:
            # def correct_user
            #   @micropost = current_user.microposts.find(params[:id])
            # rescue
            #   redirect_to root_url
            # end
end