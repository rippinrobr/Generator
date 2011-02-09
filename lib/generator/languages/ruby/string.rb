class String
  def clean_name
    cap_index = self.index(/[a-z][A-Z]/)
    #puts "cap_index = #{cap_index}"
    if cap_index.to_i > 0
      self.insert(cap_index.to_i+1, "_")
    end
    self.gsub('"','').gsub(/ +|\.|'|\\|\//,'_').downcase
  end
end

module PropertyUtils
  def PropertyUtils.generate_name(index)
    "attr_#{index}"
  end
end
