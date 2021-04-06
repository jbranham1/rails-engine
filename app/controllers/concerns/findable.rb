module Findable
  extend ActiveSupport::Concern
  def find
    if params[:name].blank?
      render json: '', status: :bad_request
    else
      item = findable_class.find_by_name(params[:name])
      if item
         render json: findable_serializer.new(item)
       else
         render json: NullSerializer.new
      end
    end
  end

  def find_all
    if params[:name].nil? || params[:name] == ''
      render json: '', status: :bad_request
    else
      render json: findable_serializer.new(findable_class.find_all_by_name(params[:name]))
    end
  end

  private

  def findable_serializer
    "#{findable_class}Serializer".constantize
  end
end
