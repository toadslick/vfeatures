class FeaturesController < ApplicationController

  def index
    @features = Feature.all
  end

  def show
    @feature = find_feature
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def find_feature
    Feature
      .includes({ flags: :release })
      .find(params.require(:id))
  end
end
