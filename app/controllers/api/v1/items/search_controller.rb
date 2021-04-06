class Api::V1::Items::SearchController < ApplicationController
  include Findable

  private

  def findable_class
    Item
  end
end
