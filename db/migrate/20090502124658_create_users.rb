class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      
      t.string    :login,               :null => false
      t.string    :email,               :null => false
      t.string    :given_name,          :null => false
      t.string    :family_name,         :null => false
      
      # Authentication Fields for AuthLogic
      t.string    :crypted_password,    :null => false
      t.string    :password_salt,       :null => false
      t.string    :persistence_token,   :null => false
      t.string    :single_access_token, :null => false
      t.string    :perishable_token,    :null => false
      t.integer   :login_count,         :null => false, :default => 0
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip

      t.timestamps
    end
    
    User.reset_column_information
    User.create!(:login => 'admin',
                 :password => 'mailer',
                 :password_confirmation => 'mailer',
                 :given_name => 'Default',
                 :family_name => 'Admin',
                 :email => 'admin@nowaythisisadomainname.org.au')
    
  end

  def self.down
    drop_table :users
  end
end