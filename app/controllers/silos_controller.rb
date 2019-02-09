class SilosController < ApplicationController
  include ChangeLogger

  def index
    @silos = Silo.alphabetically
  end

  def show
    find_record
  end

  def create
    @silo = Silo.new(allowed_params)
    if log_and_save @silo
      render 'show', status: 201
    else
      render_errors @silo
    end
  end

  def update
    find_record
    @silo.assign_attributes(allowed_params)
    if log_and_save @silo
      render 'show', status: 200
    else
      render_errors @silo
    end
  end

  def destroy
    find_record
    log_and_destroy @silo
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
