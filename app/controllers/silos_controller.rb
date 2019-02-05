class SilosController < ApplicationController

  def index
    @silos = Silo.all
  end

  def show
  end

  def create
    @silo = Silo.new(allowed_params)
    if ChangeLogger.save @silo
      render 'show', status: 201
    else
      render_errors @silo
    end
  end

  def update
    @silo.assign_attributes(allowed_params)
    if ChangeLogger.save @silo
      render 'show', status: 200
    else
      render_errors @silo
    end
  end

  def destroy
    ChangeLogger.destroy @silo
    head 200
  end

  private

  def allowed_params
    params.require(:silo).permit(:key, :release_id)
  end

  def find_record
    @silo = Silo
      .includes(:release)
      .find(params.require(:id))
  end
end
