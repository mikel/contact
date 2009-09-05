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
  aasm_state :complete
  
  aasm_event :next do
    transitions :to => :edit_content,      :from => [:new], 
                :guard => Proc.new { |m| m.source == 'plain' && m.valid? }
    transitions :to => :select_html,       :from => [:new],
                :guard => Proc.new { |m| m.source == 'html' && m.valid? }
    transitions :to => :select_template,   :from => [:new], 
                :guard => Proc.new { |m| m.source == 'template' && m.valid? }
    transitions :to => :edit_content,      :from => [:select_html],
                :on_transition => Proc.new { |m| m.multipart = true }
    transitions :to => :edit_content,      :from => [:select_template],
                :on_transition => Proc.new { |m| m.update_template }
    transitions :to => :complete,          :from => [:edit_content]
  end
  
  aasm_event :previous do
    transitions :to => :edit_content,      :from => [:complete],
                :guard => Proc.new { |m| m.source == 'plain' }
    transitions :to => :select_html,       :from => [:edit_content],
                :guard => Proc.new { |m| m.source == 'html' }
    transitions :to => :select_template,   :from => [:edit_content],
                :guard => Proc.new { |m| m.source == 'template' }
    transitions :to => :new,               :from => [:select_html, :select_template]
    transitions :to => :new,               :from => [:edit_content]
  end
  
  validates_format_of :title, :with => /^.+$/i, :message => "can't be blank"
  
  has_many :attachments
  has_many :mailouts
  
  belongs_to :email_template
  belongs_to :user
  
  def state
    aasm_state
  end
  
  def nice_state
    aasm_state.humanize
  end
  
  def nice_type
    if multipart
      "Multipart Email"
    else
      "Plain Text Only"
    end
  end

  def nice_source
    case source
    when 'plain'
      "Directly Edited"
    when 'html'
      "From HTML Files"
    when 'template'
      "From Template"
    else
      ''
    end
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

  private
  
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
