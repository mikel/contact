Feature: Managing Messages
  In order for our public to receive our message
  As a user
  I want to be able to send messages

  Scenario: Going to make a new message
    Given I am logged in
    When I follow "New Message"
    Then I should be on the new message page

  Scenario: Trying to make an email without a title
    Given I am logged in
    When I follow "New Message"
    And I choose "Plain Text Only"
    And I press "Next"
    Then I should see "Title can't be blank"
    And I should see "Title"

  Scenario: Making a new plain text email message directly
    Given I am logged in
    When I follow "New Message"
    And I fill in "Title" with "My email"
    And I choose "Plain Text Only"
    And I press "Next"
    Then I should see "Plain Text"
    And I should not see "HTML Part"

  Scenario: Making a new email message from a template without a template defined
    Given I am logged in
    When I follow "New Message"
    Then I should not see "From Template"

  Scenario: Making a new email message from a template
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    When I follow "New Message"
    And I fill in "Title" with "My email"
    And I choose "message_source_template"
    And I press "Next"
    Then I should see "Select Template"

  Scenario: Making a new email message from a template and editing it
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    When I follow "New Message"
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
    When I follow "New Message"
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
    When I follow "New Message"
    And I fill in "Title" with "My email"
    And I choose "message_source_upload"
    And I press "Next"
    Then I should see "HTML File"
    And I should see "Zip File"
    
  Scenario: Making a new email message from an uploaded file and editing it
    Given I am logged in
    And there is a file called "simple_email/index.html"
    When I follow "New Message"
    And I fill in "Title" with "My email"
    And I choose "message_source_upload"
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
    When I follow "New Message"
    And I fill in "Title" with "My email"
    And I choose "message_source_upload"
    And I press "Next"
    And I attach the file at "simple_email/index.html" to "message_html_file_data"
    And I attach the file at "simple_email/images.zip" to "message_zip_file_data"
    And I press "Next"
    Then the "HTML Part" field should contain "&lt;h1&gt;Welcome to Contact, the new Rails based Newsletter &amp;amp; Mailing program&lt;/h1&gt;"
    And the "Plain Text" field should contain "Welcome to Contact, the new Rails based Newsletter &amp; Mailing program"
    And I should see "Attached Files"
    And I should see "images/rails.png"

