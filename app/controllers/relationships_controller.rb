class RelationshipsController < ApplicationController
  before_action :signed_in_user

  respond_to :html, :js                 # renders template w/ name which matches the action
  # respond_to do |format|              # only one of the following lines gets executed based on nature of request
  #   format.html { redirect_to @user }
  #   format.js                         # automatically calls create.js.erb 
  # end

  def create
    # retrieve user to be followed, then follow! that user
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_with @user
  end

  def destroy
    # find followed user, then unfollow! that user
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_with @user
  end
end