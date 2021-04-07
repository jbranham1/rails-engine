class ApplicationController < ActionController::API
  include ActionController::Helpers
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record
  helper_method :page, :per_page

  def render_404
    render json: exception.record.errors, status: :not_found
  end

  def render_invalid_record
    render json: "Invalid Record", status: :not_found
  end

  private

  def page
    params.fetch(:page, 1).to_i
  end

  def per_page
    params.fetch(:per_page, 20).to_i
  end

  def quantity
    params.fetch(:quantity, 5).to_i
  end
end
