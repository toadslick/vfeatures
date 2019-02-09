class ApplicationController < ActionController::API
  before_action :set_request_format

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: exception, status: 404
  end

  protected

  def render_errors(record)
    render json: { errors: record.errors.details }, status: 422
  end

  private

  # Force controllers to respond as if the request specified a JSON format.
  # This prevents controllers from responding with HTML by default.
  def set_request_format
    request.format = :json
  end
end
