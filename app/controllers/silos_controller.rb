class SilosController < ApplicationController

  def index
    @silos = Silo.all
  end

  def show
    @silo = find_silo
  end

  def create
    @silo = Silo.new(allowed_params)
    if @silo.save
      render 'show', status: 201
    else
      render_errors @silo
    end
  end

  def update
  end

  def destroy
  end

  private

  def allowed_params
    params.require(:silo).permit(:key, :release_id)
  end

  def find_silo
    Silo
      .includes(:release)
      .find(params.require(:id))
  end
end
