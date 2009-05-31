class Message < ActiveRecord::Base

  require 'zip/zip'

  belongs_to :email_template

  def next_step
    case state
    when nil
      initial_step
    when 'template_selected'
      self.html_part = email_template.html_part
      self.plain_part = email_template.plain_part
      'edit_content'
    when 'file_uploaded'

      'edit_content'
    else
      state
    end
  end

  def initial_step
    case source
    when 'edit'
      'edit_content'
    when 'template'
      'select_template'
    when 'upload'
      'select_file'
    else
      'new'
    end
  end

  def file_data=(data)

    filename = File.join(RAILS_ROOT, 'tmp', "#{Time.now.to_i}-#{data.original_filename}")

    File.open(filename, 'w') do |file|
      file.write data.read
    end
    
    dir = filename.chomp('.zip')
    FileUtils.mkdir(dir)

    Zip::ZipFile.open(filename) do |zipfile|
      zipfile.dir.entries('files').each do |entry|
        zipfile.extract("files/#{entry}", "#{dir}/#{entry}")
      end
    end
    
    FileUtils.rm(filename)
    
    files = Dir.glob(File.join(dir, '*.*'))
    
    files.each do |filename|
      case filename
      when /index.html$/
        self.html_part = File.read(filename)
      when /plain.txt$/
        self.plain_part = File.read(filename)
      end
    end

    FileUtils.rm_rf(dir)
  end

  def file_data
    
  end

end
