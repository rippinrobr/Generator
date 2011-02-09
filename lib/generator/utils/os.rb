module OS
  def OS.current_platform
    if OS.windows? 
      return "win32"
    end
    if OS.mac? 
      return "osx"
    end
    if OS.linux? 
      return "linux"
    end
    if OS.unix? 
      return "unix"
    end
  end

  def OS.has_dotnet?
    return OS.windows? # add an or statement that has a check for mono
  end

  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end

