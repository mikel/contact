class Mailout < ActiveRecord::Base
  include AASM
  aasm_column :aasm_state
  aasm_initial_state :new
  
  aasm_state :new
  aasm_state :select_recipients
  aasm_state :schedule_mailout
  aasm_state :confirm_mailout
  aasm_state :confirmed
  aasm_state :sent
  
  aasm_event :next do
    transitions :to => :select_recipients, :from => [:new]
    transitions :to => :schedule_mailout,  :from => [:select_recipients],
                :guard => Proc.new { |m| m.must_have_recipients }
    transitions :to => :confirm_mailout,   :from => [:schedule_mailout]
    transitions :to => :confirmed,         :from => [:confirm_mailout]
    transitions :to => :sent,              :from => [:confirmed]
  end
  
  aasm_event :previous do
    transitions :to => :confirmed,         :from => [:sent]
    transitions :to => :confirm_mailout,   :from => [:confirmed]
    transitions :to => :schedule_mailout,  :from => [:confirm_mailout]
    transitions :to => :select_recipients, :from => [:schedule_mailout]
    transitions :to => :new,               :from => [:select_recipients]
  end

  has_many :addressees
  has_many :groups,     :through => :addressees
  has_many :recipients, :through => :addressees

  belongs_to :user
  belongs_to :message
  belongs_to :sender
  
  validates_presence_of :title
  validates_presence_of :message_id, :message => "must be selected"
  
  named_scope :ready_to_send, {:conditions => ["date_scheduled < ? AND aasm_state = ?", Time.now, 'confirmed']}
  
  def state
    aasm_state
  end
  
  def nice_state
    aasm_state.humanize
  end
  
  def organization
    user.organization
  end

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

  def subscribers
    recipient_ids = Addressee.find(:all, :select => 'recipient_id',
                         :conditions => {:mailout_id => self.id}).map { |a| a.recipient_id }
    recipient_ids << Subscription.recipient_ids_for(self.group_ids)
    recipient_ids.flatten!
    recipient_ids.uniq!
    delivered_ids = Delivery.find(:all, :conditions => {:mailout_id => self.id}, :select => 'recipient_id').map { |a| a.recipient_id}
    if delivered_ids.empty?
      Recipient.find(:all, :conditions => ['id IN (?)', recipient_ids], :order => "domain")
    else
      Recipient.find(:all, :conditions => ['id IN (?) and id NOT IN (?)', recipient_ids, delivered_ids], :order => "domain")
    end
  end

  def from
    sender.from if sender
  end

  def reply_to
    sender.reply_to if sender
  end
  
  def multipart?
    message.multipart if message
  end

  def html_part
    message.html_part if message
  end
  
  def plain_part
    message.plain_part if message
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
  
end
