class PlayersController < ApplicationController
  def index
    @players = Player.all.order(created_at: :desc)
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)

    if @player.save
      redirect_to players_path, notice: "Player created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def player_params
    params.require(:player).permit(:name, :email, :country)
  end
end
