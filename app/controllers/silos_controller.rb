class SilosController < ApplicationController

  def index
    @silos = Silo.all
  end

  def show
    @silo = find_silo
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def find_silo
    Silo
      .includes(:release)
      .find(params.require(:id))
  end
end
