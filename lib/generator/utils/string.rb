
class String
  def camelize
    self.split('_').map {|w| w.capitalize}.join 
  end

  def ends_with?(char=nil)
    if char.nil?
      !(self =~ /^.*\.cs/).nil? 
    else
      reg = Regexp.new "^.*#{char}$"
      reg.match(self)
    end
  end

  def singularize
    if self.ends_with?("us")
      self
    elsif /^.*_to_.*$/.match(self).nil? && !(/(^.*)s$/.match(self)).nil?
      $1
    else
      self
    end
  end
end
