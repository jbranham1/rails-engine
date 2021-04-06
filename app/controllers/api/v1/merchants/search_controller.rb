class Api::V1::Merchants::SearchController < ApplicationController
  include Findable

  private

  def findable_class
    Merchant
  end
end
