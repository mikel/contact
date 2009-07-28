class Message < ActiveRecord::Base
  
  require 'hpricot'
  
  # Use state machine for state transitions
  include AASM
  aasm_column :aasm_state
  aasm_initial_state :new
  
  aasm_state :new
  aasm_state :select_html
  aasm_state :select_template
  aasm_state :edit_content
  aasm_state :select_recipients
  aasm_state :schedule_mailout
  aasm_state :confirm_mailout
  aasm_state :confirmed
  
  aasm_event :next do
    transitions :to => :edit_content,      :from => [:new], 
                :guard => Proc.new { |m| m.source == 'plain' }
    transitions :to => :select_html,       :from => [:new],
                :guard => Proc.new { |m| m.source == 'html' }
    transitions :to => :select_template,   :from => [:new], 
                :guard => Proc.new { |m| m.source == 'template' }
    transitions :to => :edit_content,      :from => [:select_html],
                :on_transition => Proc.new { |m| m.multipart = true }
    transitions :to => :edit_content,      :from => [:select_template],
                :on_transition => Proc.new { |m| m.update_template }
    transitions :to => :select_recipients, :from => [:edit_content]
    transitions :to => :schedule_mailout,  :from => [:select_recipients],
                :guard => Proc.new { |m| m.must_have_recipients }
    transitions :to => :confirm_mailout,   :from => [:schedule_mailout]
    transitions :to => :confirmed,         :from => [:confirm_mailout]
  end
  
  aasm_event :previous do
    transitions :to => :confirm_mailout,   :from => [:confirmed]
    transitions :to => :schedule_mailout,  :from => [:confirm_mailout]
    transitions :to => :select_recipients, :from => [:schedule_mailout]
    transitions :to => :edit_content,      :from => [:select_recipients]
    transitions :to => :new,               :from => [:select_html, :select_template]
    transitions :to => :new,               :from => [:edit_content],
                :guard => Proc.new { |m| m.source == 'plain' }
    transitions :to => :select_html,       :from => [:edit_content],
                :guard => Proc.new { |m| m.source == 'html' }
    transitions :to => :select_template,   :from => [:edit_content],
                :guard => Proc.new { |m| m.source == 'template' }
  end
  
  validates_presence_of :title
  
  def must_have_recipients
    case
    # When no recipients and we are not trying to add anyone
    when no_recipients && @recipient_selected.blank? && @group_selected.blank?
      errors.add_to_base 'Please select at least one recipient' 
      false
    # When no recipients even though we tried to add someone
    when no_recipients
      errors.add_to_base "No recipient found with '#{@recipient_selected}'"
      false
    # We have recipients and are not trying to add anyone else
    when have_recipients && @recipient_selected.blank? && @group_selected.blank?
      true
    else
      self.save
      false
    end
  end
  
  has_many :attachments

  has_many :addressees
  has_many :groups,     :through => :addressees
  has_many :recipients, :through => :addressees

  belongs_to :email_template
  belongs_to :user
  
  def state
    aasm_state
  end

  def organization
    user.organization
  end

  def update_template
    if changes.include?('email_template') || changes.include?('email_template_id')
      self.attributes = email_template.copy_attributes
      self.save
      email_template.attachments.each do |attachment|
        self.attachments.create!(attachment.attributes)
      end
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

  def have_recipients
    !no_recipients
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
