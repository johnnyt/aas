class String
  def constantize
    Aas::StringUtils.constantize self
  end

  def demodulize
    Aas::StringUtils.demodulize self
  end

  def underscore
    Aas::StringUtils.underscore self
  end
end
