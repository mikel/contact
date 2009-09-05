Feature: Manage Email Templates
  In order to be able to communicate with our publics
  As a user
  I want to be able to create email templates to be mailed out
  
  Scenario: Not being logged in and trying to make a template
    Given I am logged out
    When I go to the email templates page
    Then I should be on the login page
  
  Scenario: No templates in the system
    Given I am logged in
    When I go to the email templates page
    Then I should see "No email templates defined"
    And I should see "Make a new email template"
  
  Scenario: One template in the system
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    And there is an email template I made in the system with title "Going away"
    When I go to the email templates page
    Then I should see "Going away"

  Scenario: Making a new email template
    Given I am logged in
    When I go to the homepage
    And I follow "Templates"
    And I follow "Make a new email template"
    Then I should be on the new email templates page
  
  Scenario: Making a new email template
    Given I am logged in
    When I go to the email templates page
    And I follow "Make a new email template"
    Then I should be on the new email templates page

  Scenario: Saving a new email template
    Given I am logged in
    When I go to the new email templates page
    And I fill in "title" with "First email"
    And I fill in "Plain Part" with "From mikel@me.com"
    And I press "Create"
    Then I should be on the email templates page
    And I should see "First email"

  Scenario: Attempting to save an invalid template
    Given I am logged in
    When I go to the new email templates page
    And I fill in "Plain Part" with "From mikel@me.com"
    And I press "Create"
    Then I should see "prohibited this email template from being saved"
  
  Scenario: Showing the existing templates for this user
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    When I go to the email templates page
    Then I should see "Hello There"
    And I should see "Edit"
    And I should see "Delete"
  
  Scenario: Selecting a template to edit
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    When I go to the email templates page
    And I follow "Edit"
    Then I should see "Edit Email Template"
  
  Scenario: Updating a template
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    When I go to edit the first email template
    And I fill in "title" with "Goodbye for now"
    And I press "Update"
    Then I should be on the email templates page
    And I should see "Goodbye for now"
 
  Scenario: Deleting an email template
    Given I am logged in
    And there is an email template I made in the system with title "Hello There"
    When I go to the email templates page
    And I follow "Delete"
    Then I should be on the email templates page
    And I should not see "Hello There"
