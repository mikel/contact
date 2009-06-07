module NavigationHelpers
  # Maps a static name to a static route.
  #
  # This method is *not* designed to map from a dynamic name to a 
  # dynamic route like <tt>post_comments_path(post)</tt>. For dynamic 
  # routes like this you should *not* rely on #path_to, but write 
  # your own step definitions instead. Example:
  #
  #   Given /I am on the comments page for the "(.+)" post/ |name|
  #     post = Post.find_by_name(name)
  #     visit post_comments_path(post)
  #   end
  #
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      root_path
      
    when /the new user sessions page/
      new_user_session_path
    
    when /the users page/
      users_path

    when /the new user page/
      new_user_path

    when /the edit user page for "([^\"]*)"/
      user = User.find_by_login($1)
      edit_user_path(user.id)
      
    when /the logout page/
      new_user_session_path
      
    when /the login page/
      login_path
    
    when /the email templates page/
      email_templates_path
      
    when /the new email templates page/
      new_email_template_path
      
    when /edit the first email template/
      edit_email_template_path(EmailTemplate.find(:first))
      
    when /the recipients page/
      recipients_path
    
    when /the new recipient page/
      new_recipient_path
    
    when /edit page for recipient "([^\"]*)"$/
      first, last = $1.split
      recipient = Recipient.find_by_given_name_and_family_name(first, last)
      edit_recipient_path(recipient)
    
    when /the organizations page/
      organizations_path
    
    when /the new organization page/
      new_organization_path
    
    when /the edit page for organization "([^\"]*)"$/
      org = Organization.find_by_name($1)
      edit_organization_path(org)
    
    when /the new message page/
      new_message_path
    
    when /the messages page/
      new_message_path
      
    when /the groups page/
      groups_path
    
    # Add more page name => path mappings here
    
    when /the new group page/
      new_group_path
      
    when /the edit page for "([^\"]*)" with a "([^\"]*)" of "([^\"]*)"/
      klass = $1
      attribute = $2
      value = $3
      obj = klass.constantize.find(:first, :conditions => {attribute => value})
      instance_eval("edit_#{klass.downcase}_path(#{obj.to_param})")
      
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
    end
  end
end

World(NavigationHelpers)
