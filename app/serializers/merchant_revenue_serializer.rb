class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :revenue
  set_type :merchant_name_revenue
end
