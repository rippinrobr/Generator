class String
  def clean_name
    if / +|\.|'|\\|\/|_|"/.match(self)
      self.gsub('"','').gsub(/ +|\.|'|\\|\//,'_').camelize 
    else
      self
    end
  end
end

module PropertyUtils
  def PropertyUtils.generate_name(index)
    "Property#{index}"
  end
end
