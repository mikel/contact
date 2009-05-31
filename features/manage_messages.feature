Feature: Managing Messages
  In order for our public to receive our message
  As a user
  I want to be able to send messages

  Scenario: Going to make a new message
    Given I am logged in
    When I follow "New Message"
    Then I should be on the new message page
  
  Scenario: Making a new email message directly
    Given I am logged in
    When I follow "New Message"
    And I choose "message_source_edit"
    And I press "Next"
    Then I should see "HTML Part"
    And I should see "Plain Text"

  Scenario: Making a new email message from a template without a template defined
    Given I am logged in
    When I follow "New Message"
    Then I should not see "From Template"

  Scenario: Making a new email message from a template
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    When I follow "New Message"
    And I choose "message_source_template"
    And I press "Next"
    Then I should see "Select Template"

  Scenario: Making a new email message from a template and editing it
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    When I follow "New Message"
    And I choose "message_source_template"
    And I press "Next"
    And I select "Hello There" from "message_email_template_id"
    And I press "Next"
    Then I should see "HTML Part"
    And I should see "Plain Text"
    And the "HTML Part" field should contain "This is the html part of the email"
    And the "Plain Text" field should contain "This is the plain part of the email"

  Scenario: Making a new email message from an uploaded file
    Given I am logged in
    When I follow "New Message"
    And I choose "message_source_upload"
    And I press "Next"
    Then I should see "Select filename"

  Scenario: Making a new email message from an uploaded file and editing it
    Given I am logged in
    And there is a file called "html_and_plain_with_image.zip"
    When I follow "New Message"
    And I choose "message_source_upload"
    And I press "Next"
    And I attach the file at "html_and_plain_with_image.zip" to "Select filename"
    And I press "Next"
    Then I should see "HTML Part"
    And I should see "Plain Text"
    And the "HTML Part" field should contain "&lt;h1&gt;Welcome to Mailer, the new Rails based Newsletter / Mailing program&lt;/h1&gt"
    And the "Plain Text" field should contain "==================================================================="
