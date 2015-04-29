class TeamsController < ApplicationController

  def new
    @team = Team.new
  end

  def create 
    @team = Team.new(params[:team])
    if @team.save
      current_user.team = @team
      current_user.save
      redirect_to root_path
    else
      flash[:error] = "Please include a team name"
      render :new
    end
  end

  def update
    team = Team.find(params[:id])
    team.update_attributes(params[:team])
    redirect_to root_path
  end

  def edit
    @team = Team.find(params[:id])
    @users = @team.users
  end

  def destroy 
    @team = Team.find(params[:id])
    @team.users.each do |user|
      user.team_id = nil
      user.save
    end
    @team.destroy
    redirect_to root_path
  end

end