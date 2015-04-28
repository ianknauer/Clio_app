class UsersController < ApplicationController
  before_filter :only_myself, only: [:edit, :update]
  before_filter :find_user, only: [:status, :boot, :add, :show, :edit, :update]

  def index
    if current_user.team_id == nil
      @other_users = User.without_user(current_user)
    else
      @team_users = User.team_members(current_user)
      @other_users = User.other_members(current_user)
    end
  end

  def statuses
    @users = User.without_user(current_user)
    respond_to do |format| 
      format.json { render :json => @users.to_json(:only => [:id, :status], :methods => [:full_name]) }
    end
  end

  def boot
    @user.team_id = nil
    @user.save
    redirect_to root_path
  end

  def add 
    if @user.available_for_team?
      @user.team_id = current_user.team_id
      @user.save
    else
      flash[:error] = "That person is already on a team"
    end
    redirect_to root_path
  end

  def update
    if @user.valid?
      @user.update_attributes(params[:user])
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def only_myself
    unless current_user.id == params[:id].to_i
      flash[:alert] = "You can't edit other users' information."
      redirect_to users_path
    end
  end

  def find_user
    @user = User.find(params[:id])
  end

end
