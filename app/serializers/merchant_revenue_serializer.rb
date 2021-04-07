class MerchantRevenueSerializer
  def self.format_merchant(revenue, id)
    # {
    #   data:
    #   {
    #     id: merchant.id,
    #     attributes:
    #     {
    #       revenue: merchant.revenue
    #     }
    #   }
    # }

    {
      data: {
        id: id.to_s,
        type: "merchant_revenue",
        attributes: {
          revenue: revenue
        }
      }
    }
  end
end
