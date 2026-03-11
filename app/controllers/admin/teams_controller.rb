class Admin::TeamsController < ApplicationController
  before_action :set_team, only: [:index, :new, :create, :edit, :update, :destroy, :players, :add_players, :remove_player]

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to admin_teams_path, notice: "Team created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @teams = Team.all
  end

  def edit
    @team = Team.find_by(id: params[:id])
  end

  def update
    @team = Team.find_by(id: params[:id])

    if @team.update(team_params)
      redirect_to admin_teams_path, notice: "Team updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team = Team.find_by(id: params[:id])
    @team.destroy
    redirect_to admin_teams_path, notice: "Team deleted successfully."
  end

  def players
    @team_players = @team.team_players.includes(:player)
    @available_players = Player.where.not(id: @team.player_ids).order(:name)
  end

  def add_players
    player_ids = Array(params[:player_ids]).reject(&:blank?)

    player_ids.each do |player_id|
      TeamPlayer.find_or_create_by(team: @team, player_id: player_id)
    end

    redirect_to players_admin_team_path(@team), notice: "Players added successfully."
  end

  def remove_player
    team_player = @team.team_players.find_by(player_id: params[:player_id])
    team_player&.destroy

    redirect_to players_admin_team_path(@team), notice: "Player removed successfully."
  end

  private

  def set_team
    @team = Team.find(params[:id]) if params[:id]
  end

  def team_params
    params.require(:team).permit(:name)
  end
end
