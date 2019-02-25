class SilosController < ApplicationController
  include ChangeLogger

  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :find_record, only: [:show, :update, :destroy]

  def index
    @silos = Silo.alphabetically
  end

  def show
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
    @silo.assign_attributes(allowed_params)
    if log_and_save @silo
      render 'show', status: 200
    else
      render_errors @silo
    end
  end

  def destroy
    log_and_destroy @silo
    head 204
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
