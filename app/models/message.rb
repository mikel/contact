class Message < ActiveRecord::Base

  require 'hpricot'

  validates_presence_of :title
  
  validate :must_have_recipients, :if => Proc.new { |m| m.state == 'recipients_selected' }  
  
  def must_have_recipients
    true == true
    case
    when no_recipients && @recipient_selected.blank? && @group_selected.blank?
      errors.add_to_base 'Please select at least one recipient' 
      false
    when no_recipients
      errors.add_to_base "No recipient found with '#{@recipient_selected}'"
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
  
  def before_validation
    self.multipart = true if state == 'new' && source == 'upload'
  end

  def after_save
    update_template if changes.include?('email_template') || changes.include?('email_template_id')
  end

  def organization
    user.organization
  end

  def update_template
    self.attributes = email_template.copy_attributes
    email_template.attachments.each do |attachment|
      self.attachments.create!(attachment.attributes)
    end
  end

  def next_step
    case
    when state == 'new' && source == 'edit'
      'edit_content'
    when state == 'new' && source == 'template'
      'select_template'
    when state == 'new' && source == 'upload'
      'select_files'
    when state == 'content_edited'
      'select_recipients'
    when state == 'file_uploaded'
      'edit_content'
    when state == 'template_selected'
      'edit_content'
    when state == 'recipients_selected'
      if @recipient_selected.blank? && @group_selected.blank? && must_have_recipients
        'schedule_mailout'
      else
        'select_recipients'
      end
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
    @group_selected
  end
  
  def add_group_id=(group_selected)
    @group_selected = group_selected
    do_add_group unless @group_selected.blank?
  end

  def add_recipient
    @recipient_selected
  end
  
  def add_recipient=(recipient_selected)
    @recipient_selected = recipient_selected
    do_add_recipients
  end

  private

  def do_add_group
    @group = Group.find(@group_selected)
    self.groups << @group unless self.groups.include?(@group)
  end

  def do_add_recipients

    case @recipient_selected
    when /@/ # Probably an email address
      @recipient = Recipient.find(:first, :conditions => {:email => @recipient_selected})
    when /\s/
      given, family = @recipient_selected.to_s.split(" ", 2)
      @recipient = Recipient.find(:first, :conditions => {:given_name => given, :family_name => family})
    end

    unless @recipient.nil?
      self.recipients << @recipient unless self.recipients.include?(@recipient)
    end

  end

  def no_recipients
    (recipients.length == 0) && (groups.length == 0)
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
