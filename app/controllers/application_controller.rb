class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response


  def render_404
    render :template => "errors/error_404", status: :not_found
  end

  def render_unprocessable_entity_response
    render json: exception.record.errors, status: :unprocessable_entity
  end
end
