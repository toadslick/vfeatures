class FeaturesController < ApplicationController

  def index
    @features = Feature.all
  end

  def show
    @feature = find_feature
  end

  def create
    @feature = Feature.build_with_flags(feature_params)
    if @feature.save
      render 'show', status: 201
    else
      render_errors @feature
    end
  end

  def update
  end

  def destroy
  end

  private

  def feature_params
    params.require(:feature).permit(:key)
  end

  def find_feature
    Feature
      .includes({ flags: :release })
      .find(params.require(:id))
  end
end
