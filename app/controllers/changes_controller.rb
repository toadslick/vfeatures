class ChangesController < ApplicationController

  def index
    Change.all
  end

  private

  def records_per_page
    20
  end
end
