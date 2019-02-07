class ChangesController < ApplicationController

  def index
    Change.all
  end

end
