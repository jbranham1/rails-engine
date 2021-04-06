module Findable
  extend ActiveSupport::Concern

  included do
    before_action :validate_params
  end

  def validate_params
    if name_param.blank?
      render json: '', status: :bad_request
    end
  end

  def find
    resource = findable_class.find_by_name(name_param)
    if resource
       render json: findable_serializer.new(resource)
     else
       render json: NullSerializer.new
    end
  end

  def find_all
    resources = findable_class.find_all_by_name(name_param)
    render json: findable_serializer.new(resources)
  end

  private

  def findable_serializer
    "#{findable_class}Serializer".constantize
  end

  def name_param
    params[:name]
  end
end
