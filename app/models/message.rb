class Message < ActiveRecord::Base

  require 'hpricot'

  validates_presence_of :title

  has_many :attachments

  belongs_to :email_template
  belongs_to :user

  def next_step
    case state
    when nil
      initial_step
    when 'template_selected'
      self.html_part = email_template.html_part
      self.plain_part = email_template.plain_part
      'edit_content'
    when 'file_uploaded'
      self.save
      'edit_content'
    else
      state
    end
  end

  def initial_step
    case source
    when 'edit'
      'plain_text'
    when 'template'
      'select_template'
    when 'upload'
      'select_files'
    else
      'new'
    end
  end

  def html_file_data=(data)
    self.html_part = data.read
    self.plain_part = strip(html_part)
  end
  
  def strip(html)
    Hpricot(html).to_plain_text.gsub(/\s+/, "\s").gsub(/\n\n+/, "\n")
  end

  def zip_file_data=(data)
    return unless data.respond_to?(:read)
    
    filename  = File.join(RAILS_ROOT, 'tmp', "#{Time.now.to_i}_#{data.original_filename}")
    directory = data.original_filename.chomp(".zip")
    path      = File.join(RAILS_ROOT, 'tmp', "#{Time.now.to_i}_#{directory}")

    File.open(filename, 'w') do |f|
      f.write data.read
    end
    
    FileUtils.mkdir(path)
    
    FileUtils.cd(path) {
      `#{APP_CONFIG[:unzip]} #{APP_CONFIG[:unzip_params]} #{filename}`
    }
    
    filenames = Dir.glob(File.join(path, directory, "*"))
    
    filenames.each do |f|
      next if File.directory?(f)
      next if f =~ /^\./ # Get rid of system entries
      file = File.open(f, 'r')
      self.attachments.create(:filename  => File.basename(f),
                              :directory => directory,
                              :data      => file.read )
    end
    
    # Cleanup
    FileUtils.rm(filename)
    FileUtils.rm_rf(directory)
    
  end

end
