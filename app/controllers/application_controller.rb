class ApplicationController < ActionController::API
  include ActionController::Helpers
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::Rollback, with: :render_rollback
  helper_method :page, :per_page

  def render_404
    render json: exception.record.errors, status: :not_found
  end

  def render_unprocessable_entity_response
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def render_rollback
    render json: exception.record.errors, status: :not_found
  end

  def page
    params.fetch(:page, 1).to_i
  end

  def per_page
    params.fetch(:per_page, 20).to_i
  end
end
