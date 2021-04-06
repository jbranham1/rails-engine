class ErrorSerializer
  def as_json(_options = nil)
    {
      error: {}
    }
  end
end
