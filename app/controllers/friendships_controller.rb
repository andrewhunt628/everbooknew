class FriendshipsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @friends = current_user.friends
  end

  def new
    @users = User.all :conditions => ["id != ?", current_user.id]
  end

  def create
    invitee = User.find_by_id params[:user_id]
    url = request.base_url

    if current_user.friend_request(invitee)
      FriendshipNotifications.new_invitation(current_user, invitee, url).deliver_now
      flash[:notice] = "Successfully sent invite"
    else
      flash[:notice] = "Sorry! You can't invite that user!"
    end

    redirect_to :back
  end

  def update
    inviter = User.find_by_id params[:id]

    current_user.accept_request(inviter) ?
      flash[:notice] = 'Successfully confirmed friend!' :
      flash[:notice] = "Sorry! Could not confirm friend!"

    redirect_to :back
  end

  def confirm
    inviter = User.find_by_id params[:id]

    current_user.accept_request(inviter) ?
      flash[:notice] = 'Successfully confirmed friend!' :
      flash[:notice] = "Sorry! Could not confirm friend!"

    redirect_to explore_path
  end

  def requests
    @pending_requests = current_user.pending_invited_by
  end

  def invites
    @pending_invites = current_user.pending_invited
  end

  def destroy
    user = User.find_by_id(params[:id])
    if current_user.remove_friendship user
      redirect_to friends_path, :notice => "Successfully removed friend!"
    else
      redirect_to friends_path, :notice => "Sorry, couldn't remove friend!"
    end
  end

end
