class FeaturesController < ApplicationController

  def index
    @features = Feature.all
  end

  def show
    @feature = find_feature
  end

  def create
    @feature = Feature.build_with_flags(params_for_create)
    if @feature.save
      render 'show', status: 201
    else
      render_errors @feature
    end
  end

  def update
    @feature = find_feature
    if @feature.update_attributes(params_for_update)
      render 'show', status: 200
    else
      render_errors @feature
    end
  end

  def destroy
  end

  private

  def params_for_create
    params
      .require(:feature)
      .permit(:key)
  end

  def params_for_update
    params
      .require(:feature)
      .permit(:key, {
        flags_attributes: [
          :id, :enabled,
        ]
      })
  end

  def find_feature
    Feature
      .includes({ flags: :release })
      .find(params.require(:id))
  end
end
