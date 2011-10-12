class String
  def clean_name
    cap_index = self.index(/[a-z][A-Z]/)
    if cap_index.to_i > 0
      self.insert(cap_index.to_i+1, "_")
    end
    self.gsub('"','')
    self.gsub(/ +|\.|'|\\|\/|-/,'_')
    self.sub(".","_")
    self.downcase 
  end
end

module PropertyUtils
  def PropertyUtils.generate_name(index)
    "attr_#{index}"
  end
end
