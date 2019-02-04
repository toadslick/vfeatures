class FeaturesController < ApplicationController

  def index
    @features = Feature.all
  end

  def show
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
    @feature.assign_attributes(params_for_update)
    if @feature.save
      render 'show', status: 200
    else
      render_errors @feature
    end
  end

  def destroy
    @feature.destroy
    head 200
  end

  private

  # When creating a feature,
  # only the 'key' of the feature may be specified.
  def params_for_create
    params
      .require(:feature)
      .permit(:key)
  end

  # When updating a feature,
  # allow the 'enabled' status of any associated flags to be updated.
  def params_for_update
    params
      .require(:feature)
      .permit(:key, {
        flags_attributes: [
          :id, :enabled
        ]
      })
  end

  # Reduce the number of database queries by including all flags associated
  # with the feature in a single query.
  def find_record
    @feature = Feature
      .includes(:flags)
      .find(params.require(:id))
  end
end
