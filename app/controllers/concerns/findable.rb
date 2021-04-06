module Findable
  extend ActiveSupport::Concern

  included do
    before_action :validate_params
  end

  def validate_params
    if name_param.blank? && min_param.blank? && max_param.blank?
      render json: ErrorSerializer.new, status: :bad_request
    elsif ((min_param || max_param) && name_param) || (min_param.to_i < 0 || max_param.to_i < 0)
      render json: ErrorSerializer.new, status: :bad_request
    elsif (min_param && max_param && min_param > max_param)
      render json: ErrorSerializer.new, status: :bad_request
    end
  end

  def find
    if name_param
      resource = findable_class.find_by_name(name_param)
    elsif min_param && max_param
      resource = findable_class.find_one_by_price_range(min_param, max_param)
    elsif min_param
      resource = findable_class.find_one_by_min_price(min_param)
    elsif max_param
      resource = findable_class.find_one_by_max_price(max_param)
    end
    if resource
       render json: findable_serializer.new(resource)
     else
       render json: NullSerializer.new
    end
  end

  def find_all
    if name_param
      resources = findable_class.find_all_by_name(name_param)
    elsif min_param && max_param
      resources = findable_class.find_all_by_price_range(min_param, max_param)
    elsif min_param
      resources = findable_class.find_all_by_min_price(min_param)
    elsif max_param
      resources = findable_class.find_all_by_max_price(max_param)
    end
    render json: findable_serializer.new(resources)
  end

  private

  def findable_serializer
    "#{findable_class}Serializer".constantize
  end

  def name_param
    params[:name]
  end

  def min_param
    params[:min_price]
  end

  def max_param
    params[:max_price]
  end
end
