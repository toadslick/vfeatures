class FlagsController < ApplicationController

  def show
  end

  def update
    @flag.assign_attributes(allowed_params)
    if ChangeLogger.save @flag
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
