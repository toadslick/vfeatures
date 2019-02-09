class FlagsController < ApplicationController
  include ChangeLogger

  before_action :authenticate_user!, only: [:update]
  before_action :find_record, only: [:show, :update]

  def show
  end

  def update
    @flag.assign_attributes(allowed_params)
    if log_and_save @flag
      render 'show', status: 200
    else
      render_errors @flag
    end
  end

  private

  def allowed_params
    params.require(:flag).permit(:enabled)
  end

  def find_record
    @flag = Flag
      .includes(:release, :feature)
      .find(params.require(:id))
  end
end
