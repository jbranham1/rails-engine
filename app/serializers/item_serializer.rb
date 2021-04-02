class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :unit_price, :merchant_id

  def merchant_id
    MerchantSerializer.new(object.merchant_id, { root: false })
  end
end
