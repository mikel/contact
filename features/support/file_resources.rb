module FileHelpers
  # Mapes file names to resource specific files. This then becomes
  # a centralized place where you can control all your files and
  # define what they are.
  #
  # In many cases, the actual when case is empty of code, and just
  # holds an explanation.
  def make_file(filename)
    
    filename = defaultize(filename)
    
    case filename
    
    when %r[resources/email.zip]
      # file has a basic email in it with an index.html
      # a plain.txt file and a single image
    
    # Add more filename => file creation routines here
    
    end
    check(filename)
    
  end

  private
  
  def defaultize(filename)
    unless filename =~ /^[\.\/]/
      filename = File.join(RAILS_ROOT, 'features', 'resources', filename)
    else
      filename
    end
  end
  
  def check(filename)
    if file_exists?(filename)
      return true
    else
      raise missing_file(filename)
    end
  end

  def file_exists?(filename)
    File.exists?(filename)
  end

  def missing_file(filename)
    raise "Can't find file \"#{filename}\".\n" +
      "Please ensure this file exists"
  end
  
end

World(FileHelpers)
