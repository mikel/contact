module FileHelpers
  # Mapes file names to resource specific files. This then becomes
  # a centralized place where you can control all your files and
  # define what they are.
  #
  # In many cases, the actual when case is empty of code, and just
  # holds an explanation.
  def make_file(filename)
    
    filename = defaultize(filename.to_s)
    
    case filename
    
    when %r[simple_email/index.html]
      # Email file containing one link to an image
      created_filename = filename
    when %r[resources/images.zip]
      # contains the images folder
      created_filename = filename
    
    when %r[rails.png]
      # Sample graphic
      created_filename = filename
    
    else

    end
    check_exists(created_filename.to_s)
    
  end

  private
  
  def defaultize(filename)
    unless filename =~ /^[\.\/]/
      filename = File.join(RAILS_ROOT, 'features', 'resources', filename)
    else
      filename
    end
  end
  
  def check_exists(filename)
    if file_exists?(filename)
      return filename
    else
      raise missing_file(filename)
    end
  end

  def file_exists?(filename)
    File.exists?(filename)
  end

  def missing_file(filename)
    raise "Can't find definition for file \"#{filename}\".\n" +
      "Please ensure this file exists and is defined in 'file_resources.rb'"
  end
  
end

World(FileHelpers)
