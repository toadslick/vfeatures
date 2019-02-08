class ChangesController < ApplicationController
  include Pagination

  def index
    @changes = paginate(query)
  end

  private

  WHERE_PARAMS = %i(
    target_type
    target_id
    target_key
  )

  def query
    Change.latest.where(params.permit(*WHERE_PARAMS).slice(*WHERE_PARAMS))
  end
end
