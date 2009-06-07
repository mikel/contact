class Message < ActiveRecord::Base

  require 'hpricot'

  validates_presence_of :title
  
  validate :must_have_recipients, :if => Proc.new { |message| message.state == 'select_recipients' }  
  
  def must_have_recipients
    if no_recipients
      self.state = 'select_recipients'
      errors.add_to_base 'Please select at least one recipient' 
      false
    else
      true
    end
  end
  
  has_many :attachments

  has_many :addressees
  has_many :groups,     :through => :addressees
  has_many :recipients, :through => :addressees

  belongs_to :email_template
  belongs_to :user

  def next_step
    return @state if @state
    @state = case state
    when nil
      initial_step
    when 'template_selected'
      self.attributes = email_template.copy_attributes
      email_template.attachments.each do |attachment|
        self.attachments.create!(attachment.attributes)
      end
      'edit_content'
    when 'file_uploaded'
      'edit_content'
    when 'content_edited'
      'select_recipients'
    when 'recipients_selected'
      if @recipient_selected.blank? && @group_selected.blank? && must_have_recipients
        'schedule_mailout'
      else
        do_add_recipients unless @recipient_selected.blank?
        do_add_group unless @group_selected.blank?
        'select_recipients'
      end
    else
      state
    end
  end

  def initial_step
    case source
    when 'edit'
      self.update_attribute(:multipart, false)
      'edit_content'
    when 'template'
      'select_template'
    when 'upload'
      self.update_attribute(:multipart, true)
      'select_files'
    else
      'new'
    end
  end

  def html_file_data=(data)
    self.html_part = data.read
    self.plain_part = strip(html_part)
  end

  def zip_file_data=(data)
    return unless data.respond_to?(:read)
    extract_file_data(data)
  end

  def add_group_id
    nil
  end
  
  def add_group_id=(group_selected)
    @group_selected = group_selected
  end

  def add_recipient
    nil
  end
  
  def add_recipient=(recipient_selected)
    @recipient_selected = recipient_selected
  end

  private


  def do_add_group
    Addressee.create!(:message_id => self.id, :group_id => @group_selected)
    self.state = 'select_recipients'
  end

  def do_add_recipients
    case @recipient_selected
    when /@/ # Probably an email address
      @recipient = Recipient.find(:first, :conditions => {:email => @recipient_selected})
      self.errors.add_to_base("No recipient found with '#{recipient_detail}'") unless @recipient
    when /\s/
      given, family = @recipient_selected.to_s.split(" ", 2)
      @recipient = Recipient.find(:first, :conditions => {:given_name => given, :family_name => family})
      self.errors.add_to_base("No recipient found with '#{recipient_detail}'") unless @recipient
    end

    if @recipient
      Addressee.create!(:message_id => self.id, :recipient_id => @recipient.id)
    end
  end

  def no_recipients
    @no_recipients ||= (recipients.empty? && groups.empty?)
  end
  
  def strip(html)
    Hpricot(html).to_plain_text.gsub(/\s+/, "\s").gsub(/\n\n+/, "\n")
  end

  def extract_file_data(data)
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
