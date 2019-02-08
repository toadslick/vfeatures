module Pagination
  extend ActiveSupport::Concern

  def paginate(query)
    @pagination = PageInfo.new(query.count, page_param * records_per_page)
    query.limit(records_per_page).offset(@pagination.offset)
  end

  def records_per_page
    20
  end

  private

  def page_param
    params.permit(:page)[:page].to_i
  end
end


PageInfo = Struct.new(:total, :offset)
