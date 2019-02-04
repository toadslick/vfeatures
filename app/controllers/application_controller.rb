class ApplicationController < ActionController::API
  before_action :set_request_format
  before_action :find_record, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: exception, status: 404
  end

  protected

  def render_errors(record)
    render json: { errors: record.errors.details }, status: 422
  end

  # Stub of a method for logging record transactions.
  def log(method, record)
    action = record.new_record? ? 'create' : 'update'
    result = record.send(method)
    action = record.destroyed? ? 'destroy' : action
    p "LOG ACTION: #{action} #{record.class}"
    result
  end

  private

  # Force controllers to respond as if the request specified a JSON format.
  # This prevents controllers from responding with HTML by default.
  def set_request_format
    request.format = :json
  end
end
