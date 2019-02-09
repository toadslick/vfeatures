class FeaturesController < ApplicationController
  include ChangeLogger

  def index
    @features = Feature.alphabetically
  end

  def show
    find_record
  end

  def create
    @feature = Feature.build_with_flags(params_for_create)
    if log_and_save @feature
      render 'show', status: 201
    else
      render_errors @feature
    end
  end

  def update
    find_record
    @feature.assign_attributes(params_for_update)
    if log_and_save @feature
      render 'show', status: 200
    else
      render_errors @feature
    end
  end

  def destroy
    find_record
    log_and_destroy @feature
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
      .permit(:key)
  end

  # Reduce the number of database queries by including all flags associated
  # with the feature in a single query.
  def find_record
    @feature = Feature
      .includes(:flags)
      .find(params.require(:id))
  end
end
