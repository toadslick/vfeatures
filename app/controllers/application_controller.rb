class ApplicationController < ActionController::API
  before_action :set_request_format

  protected

  def render_errors(record)
    render json: { errors: record.errors.details }, status: 422
  end

  private

  def set_request_format
    request.format = :json
  end
end
