class NullSerializer
  def as_json(_options = nil)
    {
      data: {}
    }
  end
end
