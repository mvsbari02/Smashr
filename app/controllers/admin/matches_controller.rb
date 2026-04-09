class Admin::MatchesController < ApplicationController
  def index
    @matches = Match.includes(:team1, :team2, :winner_team).order(started_at: :desc)
  end

  def new
    @match = Match.new
    @teams = Team.order(:name)
  end

  def create
    @match = Match.new(match_params)
    @teams = Team.order(:name)

    if @match.save
      redirect_to admin_matches_path, notice: "Match created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @match = Match.includes(:games).find(params[:id])
    @teams = Team.order(:name)
  end

  def update
    @match = Match.find(params[:id])
    @teams = Team.order(:name)

    if @match.update(match_params)
      redirect_to admin_matches_path, notice: "Match updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy
    redirect_to admin_matches_path, notice: "Match deleted successfully."
  end

  private

  def match_params
    params.require(:match).permit(
      :match_type,
      :team1_id,
      :team2_id,
      :winner_team_id,
      :started_at,
      :ended_at,
      :best_of,
      games_attributes: [
        :id,
        :team1_score,
        :team2_score,
        :winner_team_id
      ]
    )
  end
end
