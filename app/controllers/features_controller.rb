class FeaturesController < ApplicationController

  def index
    @features = Feature.all
  end

  def show
    @feature = find_feature
  end

  def create
    required_params = params.require(:feature).permit(:key)
    @feature = Feature.build_with_flags(required_params)
    if @feature.save
      render 'show', status: 201
    else
      render_errors @feature
    end
  end

  def update
    required_params = params.require(:feature).permit(:key, :flags_attributes)
    @feature = find_feature
    if @feature.update_attributes(required_params)
      render 'show', status: 200
    else
      render_errors @feature
    end
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
