Feature: Managing Messages
  In order to create a message to send
  As a user
  I want to be able to create a message using a step by step wizard

  Scenario: Going to make a new message
    Given I am logged in
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    Then I should be on the new message page
    And I should see "Enter Title and Type of Mailout"

  Scenario: Trying to make an email without a title
    Given I am logged in
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I choose "Plain Text Only"
    And I press "Next"
    Then I should see "Title can't be blank"
    And I should see "Title"
    And I should see "Enter Title and Type of Mailout"

  Scenario: Making a new plain text email message directly
    Given I am logged in
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My email"
    And I choose "Plain Text Only"
    And I press "Next"
    Then I should see "Plain Text"
    And I should not see "HTML Part"

  Scenario: Making a new email message from a template without a template defined
    Given I am logged in
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    Then I should not see "From Template"

  Scenario: Making a new email message from a template
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My email"
    And I choose "message_source_template"
    And I press "Next"
    Then I should see "Select Template"

  Scenario: Making a new email message from a template and editing it
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My email"
    And I choose "message_source_template"
    And I press "Next"
    And I select "Hello There" from "message_email_template_id"
    And I press "Next"
    Then I should see "HTML Part"
    And I should see "Plain Text"
    And the "HTML Part" field should contain "This is the html part of the email"
    And the "Plain Text" field should contain "This is the plain part of the email"

  Scenario: Making a new email message from a template that includes an image and editing it
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    And the email template entitled "Hello There" has an image attached called "rails.png"
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My email"
    And I choose "message_source_template"
    And I press "Next"
    And I select "Hello There" from "message_email_template_id"
    And I press "Next"
    Then the "HTML Part" field should contain "This is the html part of the email"
    And the "Plain Text" field should contain "This is the plain part of the email"
    And I should see "Attached Files"
    And I should see "images/rails.png"

  Scenario: Making a new email message from an uploaded file
    Given I am logged in
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My email"
    And I choose "message_source_html"
    And I press "Next"
    Then I should see "HTML File"
    And I should see "Zip File"
    
  Scenario: Making a new email message from an uploaded file and editing it
    Given I am logged in
    And there is a file called "simple_email/index.html"
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My email"
    And I choose "message_source_html"
    And I press "Next"
    And I attach the file at "simple_email/index.html" to "message_html_file_data"
    And I press "Next"
    Then I should see "HTML Part"
    And I should see "Plain Text"
    And I should not see "Attached Files:"
    And the "HTML Part" field should contain "&lt;h1&gt;Welcome to Contact, the new Rails based Newsletter &amp;amp; Mailing program&lt;/h1&gt;"
    And the "Plain Text" field should contain "Welcome to Contact, the new Rails based Newsletter &amp; Mailing program"
    
  Scenario: Making a new email message from an uploaded file with images and editing it
    Given I am logged in
    And there is a file called "simple_email/index.html"
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My email"
    And I choose "message_source_html"
    And I press "Next"
    And I attach the file at "simple_email/index.html" to "message_html_file_data"
    And I attach the file at "simple_email/images.zip" to "message_zip_file_data"
    And I press "Next"
    Then the "HTML Part" field should contain "&lt;h1&gt;Welcome to Contact, the new Rails based Newsletter &amp;amp; Mailing program&lt;/h1&gt;"
    And the "Plain Text" field should contain "Welcome to Contact, the new Rails based Newsletter &amp; Mailing program"
    And I should see "Attached Files"
    And I should see "images/rails.png"

  Scenario: Saving a created message
    Given I am logged in
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My new email"
    And I choose "Plain Text Only"
    And I press "Next"
    And I fill in "Plain Text" with "This is the email I am sending out"
    And I press "Next"
    Then I should see "Select Recipients"

  Scenario: Selecting recipients for a message
    Given I am logged in
    And there is a group in the system called "Public"
    And there is a recipient I added in the system called "Mikel Lindsaar"
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My new email"
    And I choose "Plain Text Only"
    And I press "Next"
    And I fill in "Plain Text" with "This is the email I am sending out"
    And I press "Next"
    And I select "Public" from "Add Group"
    And I fill in "Add Recipient" with "Mikel Lindsaar"
    And I press "Next"
    Then I should see "Select Recipients"
    And the "message" with "title" of "My new email" should have a "group" with "name" of "Public"
    And the "message" with "title" of "My new email" should have a "recipient" with "given_name" of "Mikel"

  Scenario: Selecting a recipient for a message should not show a validation error
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My new email"
    And I choose "Plain Text Only"
    And I press "Next"
    And I fill in "Plain Text" with "This is the email I am sending out"
    And I press "Next"
    And I fill in "Add Recipient" with "Mikel Lindsaar"
    And I press "Next"
    Then I should not see "prohibited this message from being saved"

  Scenario: Selecting a group for a message should not show a validation error
    Given I am logged in
    And there is a group in the system called "Public"
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My new email"
    And I choose "Plain Text Only"
    And I press "Next"
    And I fill in "Plain Text" with "This is the email I am sending out"
    And I press "Next"
    And I select "Public" from "Add Group"
    And I press "Next"
    Then I should not see "prohibited this message from being saved"

  Scenario: Trying to add the same recipient twice
    Given I am logged in
    And there is a group in the system called "Public"
    And there is a recipient I added in the system called "Mikel Lindsaar"
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My new email"
    And I choose "Plain Text Only"
    And I press "Next"
    And I fill in "Plain Text" with "This is the email I am sending out"
    And I press "Next"
    And I fill in "Add Recipient" with "Mikel Lindsaar"
    And I press "Next"
    And I fill in "Add Recipient" with "Mikel Lindsaar"
    And I press "Next"
    Then I should see "Select Recipients"
    And the message entitled "My new email" should have one recipient

  Scenario: Trying to add the same group twice
    Given I am logged in
    And there is a group in the system called "Public"
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My new email"
    And I choose "Plain Text Only"
    And I press "Next"
    And I fill in "Plain Text" with "This is the email I am sending out"
    And I press "Next"
    And I select "Public" from "Add Group"
    And I press "Next"
    And I select "Public" from "Add Group"
    And I press "Next"
    Then I should see "Select Recipients"
    And the message entitled "My new email" should have one group
    
  Scenario: Selecting no recipients for a message
    Given I am logged in
    And there is a message called "My Email" in the system
    When I go to the edit page for "Message" with a "title" of "My Email"
    And I press "Next"
    Then I should see "Select Recipients"
    And I should see "Please select at least one recipient"

  Scenario: Saving a created message
    Given I am logged in
    And there is a group in the system called "Public"
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My new email"
    And I choose "Plain Text Only"
    And I press "Next"
    And I fill in "Plain Text" with "This is the email I am sending out"
    And I press "Next"
    And I select "Public" from "Add Group"
    And I press "Next"
    And I press "Next"
    Then I should see "Schedule Mailout"

  Scenario: Removing a recipient from a created message
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is a message called "My Email" in the system with "Mikel Lindsaar" as a recipient
    When I go to the edit page for "Message" with a "title" of "My Email"
    And I follow "Remove"
    Then I should see "Select Recipients"
    And the message called "My Email" should have no recipients

  Scenario: Removing a group from a created message
    Given I am logged in
    And there is a group in the system called "Public"
    And there is a message called "My Email" in the system with "Public" as a group
    When I go to the edit page for "Message" with a "title" of "My Email"
    And I follow "Remove"
    Then I should see "Select Recipients"
    And the message called "My Email" should have no groups
  
  Scenario: Scheduling a message
    Given I am logged in
    And there is a group in the system called "Public"
    And there is a message called "My Email" in the system with "Public" as a group
    When I go to the edit page for "Message" with a "title" of "My Email"
    And I press "Next"
    Then I should see "Schedule Mailout"
  
  Scenario: Scheduling a message to be sent out in the future
    Given I am logged in
    And there is a group in the system called "Public"
    And there is a message called "My Email" in the system with "Public" as a group
    When I go to the edit page for "Message" with a "title" of "My Email"
    And I press "Next"
    And I select "December 25, 2010 20:12" as the date and time
    And I press "Next"
    Then I should see "Confirm Mailout"
    And the message called "My Email" should have a scheduled time of "December 25, 2010 20:12"

  Scenario: Confirming a mailout
    Given I am logged in
    And there is a group in the system called "Public"
    And there is a message called "My Email" in the system with "Public" as a group
    When I go to the edit page for "Message" with a "title" of "My Email"
    And I press "Next"
    And I select "December 25, 2010 20:12" as the date and time
    And I press "Next"
    Then I should see "Confirm Mailout"
    And I should see "Title"
    And I should see "My Email"
    And I should see "Date Scheduled"
    And I should see "2010-12-25 20:12:00 UTC"
    And I should see "Groups"
    And I should see "Public"
    And I should see "Recipients"

  Scenario: Approving a mailout
    Given I am logged in
    And there is a group in the system called "Public"
    And there is a message called "My Email" in the system with "Public" as a group that has been scheduled
    When I go to the edit page for "Message" with a "title" of "My Email"
    And I press "Confirm Mailout"
    Then I should be on the messages page
