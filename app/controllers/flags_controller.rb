class FlagsController < ApplicationController
  include ChangeLogger

  def show
    find_record
  end

  def update
    find_record
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
