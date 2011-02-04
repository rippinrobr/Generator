class Array
  def find_dups
    uniq.map {|v| (self - [v]).size < (self.size - 1) ? v : nil}.compact
  end
end
