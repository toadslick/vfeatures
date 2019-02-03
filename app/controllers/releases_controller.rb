class ReleasesController < ApplicationController

  def index
    @releases = Release.all
  end

  def show
    @release = find_release
  end

  def create
    @release = Release.build_with_flags(params_for_create)
    if @release.save
      render 'show', status: 201
    else
      render_errors @release
    end
  end

  def update
    @release = find_release
    if @release.update_attributes(params_for_update)
      render 'show', status: 200
    else
      render_errors @release
    end
  end

  def destroy
    find_release.destroy
    head 200
  end

  private

  # When creating a release,
  # only the 'key' of the release may be specified.
  def params_for_create
    params
      .require(:release)
      .permit(:key)
  end

  # When updating a release,
  # allow the 'enabled' status of any associated flags to be updated.
  def params_for_update
    params
      .require(:release)
      .permit(:key, {
        flags_attributes: [
          :id, :enabled
        ]
      })
  end

  # Reduce the number of database queries by including all flags associated
  # with the release in a single query.
  def find_release
    Release
      .includes(:flags)
      .find(params.require(:id))
  end
end
