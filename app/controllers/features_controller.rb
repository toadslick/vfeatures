class FeaturesController < ApplicationController

  def index
    render json: Feature.all
  end

  def show
    render json: feature
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def feature
    Feature
      .includes({ flags: :release })
      .find(params.require(:id))
  end

end
