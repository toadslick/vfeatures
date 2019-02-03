class ApplicationController < ActionController::API
  before_action :set_request_format

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: exception, status: 404
  end

  protected

  def render_errors(record)
    render json: { errors: record.errors.details }, status: 422
  end

  def render_success
    head :ok
  end

  private

  def set_request_format
    request.format = :json
  end

  rescue
end
