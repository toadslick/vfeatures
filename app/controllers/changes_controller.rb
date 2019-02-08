class ChangesController < ApplicationController

  def index
    p params
    @changes = query.page(page_number, records_per_page)
    @total = query.count
  end

  private

  WHERE_PARAMS = %w(
    target_type
    target_id
    target_key
  )

  def records_per_page
    20
  end

  def query
    Change.latest.where(params.slice(WHERE_PARAMS))
  end

  def page_number
    params[:page].to_i
  end
end
