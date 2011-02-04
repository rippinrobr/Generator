class String
  def clean_name
    self.gsub('"','').gsub(/ +|\.|'|\\|\//,'_').camelize
  end
end

module PropertyUtils
  def PropertyUtils.generate_name(index)
    "Property#{index}"
  end
end
