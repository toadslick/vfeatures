class FlagsController < ApplicationController

  def show
    @flag = find_flag
  end

  def update
    @flag = find_flag
    if @flag.update_attributes(allowed_params)
      render 'show', status: 200
    else
      render_errors @flag
    end
  end

  private

  def allowed_params
    params.require(:flag).permit(:enabled)
  end

  def find_flag
    Flag
      .includes(:release, :feature)
      .find(params.require(:id))
  end
end
