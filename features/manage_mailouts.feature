Feature: Managing Mailouts
  In order to create a mailout to send
  As a user
  I want to be able to create a mailout using a step by step wizard

  Scenario: Creating a mailout
    Given I am logged in
    And there is a message called "My Message" in the system
    And there is a sender called "Mikel Org" in the system
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My new mailout"
    And I select "Mikel Org" from "Sender"
    And I select "My Message" from "Message"
    And I press "Next"
    Then I should see "Select Recipients"

  Scenario: Selecting recipients for a message
    Given I am logged in
    And there is a message called "My Message" in the system
    When I follow "Mailouts"
    And I follow "Make a new mailout"
    And I fill in "Title" with "My Mailout"
    And I select "My Message" from "Message"
    And I press "Next"
    Then I should see "Select Recipients"
    And the mailout called "My Mailout" should be in the "select_recipients" state

  Scenario: Selecting a recipient for a message should not show a validation error
    Given I am logged in
    And there is a mailout called "My Mailout" in the system
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And the mailout "My Mailout" is in the "select_recipients" state
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    And I fill in "Add Recipient" with "Mikel Lindsaar"
    And I press "Next"
    Then I should not see "prohibited this message from being saved"

  Scenario: Selecting a group for a message should not show a validation error
    Given I am logged in
    And there is a mailout called "My Mailout" in the system
    And there is a group in the system called "Public"
    And the mailout "My Mailout" is in the "select_recipients" state
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    Then I should see "Select Recipients"
    And I select "Public" from "Add Group"
    And I press "Next"
    Then I should not see "prohibited this message from being saved"

  Scenario: Trying to add the same recipient twice
    Given I am logged in
    And there is a mailout called "My Mailout" in the system
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And the mailout "My Mailout" is in the "select_recipients" state
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    And I fill in "Add Recipient" with "Mikel Lindsaar"
    And I press "Next"
    And I fill in "Add Recipient" with "Mikel Lindsaar"
    And I press "Next"
    Then I should see "Select Recipients"
    And the mailout entitled "My Mailout" should have one recipient

  Scenario: Trying to add the same group twice
    Given I am logged in
    And there is a mailout called "My Mailout" in the system
    And there is a group in the system called "Public"
    And the mailout "My Mailout" is in the "select_recipients" state
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    And I select "Public" from "Add Group"
    And I press "Next"
    And I select "Public" from "Add Group"
    And I press "Next"
    Then I should see "Select Recipients"
    And the mailout entitled "My Mailout" should have one group
  
  Scenario: Selecting no recipients for a message
    Given I am logged in
    And there is a mailout called "My Mailout" in the system
    And there is a group in the system called "Public"
    And the mailout "My Mailout" is in the "select_recipients" state
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    And I press "Next"
    Then I should see "Select Recipients"
    And I should see "Please select at least one recipient"

  Scenario: Saving a created message
    Given I am logged in
    And there is a mailout called "My Mailout" in the system
    And there is a group in the system called "Public"
    And the mailout "My Mailout" is in the "select_recipients" state
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    And I select "Public" from "Add Group"
    And I press "Next"
    And I press "Next"
    Then I should see "Schedule Mailout"

  Scenario: Removing a recipient from a created message
    Given I am logged in
    And there is a mailout called "My Mailout" in the system
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And the mailout "My Mailout" is in the "select_recipients" state
    And the mailout "My Mailout" has a recipient called "Mikel Lindsaar"
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    And I follow "Remove"
    Then I should see "Select Recipients"
    And the mailout called "My Mailout" should have no recipients

  Scenario: Removing a group from a created message
    Given I am logged in
    And there is a mailout called "My Mailout" in the system
    And there is a group in the system called "Public"
    And the mailout "My Mailout" is in the "select_recipients" state
    And the mailout "My Mailout" has a group called "Public"
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    And I follow "Remove"
    Then I should see "Select Recipients"
    And the mailout called "My Mailout" should have no groups

  Scenario: Scheduling a message
    Given I am logged in
    And there is a mailout called "My Mailout" in the system with a group called "Public"
    And the mailout "My Mailout" is in the "select_recipients" state
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    And I select "Public" from "Add Group"
    And I press "Next"
    And I press "Next"
    Then I should see "Schedule Mailout"
    And the mailout called "My Mailout" should be in the "schedule_mailout" state

  Scenario: Scheduling a message to be sent out in the future
    Given I am logged in
    And there is a mailout called "My Mailout" in the system with a group called "Public"
    And the mailout "My Mailout" is in the "schedule_mailout" state
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    And I select "December 25, 2010 20:12" as the date and time
    And I press "Next"
    Then I should see "Confirm Mailout"
    And the mailout called "My Mailout" should have a scheduled time of "December 25, 2010 20:12"

  Scenario: Confirming a mailout
    Given I am logged in
    And there is a mailout called "My Mailout" in the system with a group called "Public"
    And the mailout "My Mailout" is in the "schedule_mailout" state
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    And I select "December 25, 2010 20:12" as the date and time
    And I press "Next"
    Then I should see "Confirm Mailout"
    And I should see "Title"
    And I should see "My Mailout"
    And I should see "Date Scheduled"
    And I should see "2010-12-25 20:12:00 UTC"
    And I should see "Groups"
    And I should see "Public"
    And I should see "Recipients"
    And the mailout called "My Mailout" should be in the "confirm_mailout" state

  Scenario: Approving a mailout
    Given I am logged in
    And there is a mailout called "My Mailout" in the system with a group called "Public"
    And the mailout "My Mailout" is in the "confirm_mailout" state
    When I go to the edit page for "Mailout" with a "title" of "My Mailout"
    And I press "Confirm Mailout"
    Then I should be on the mailouts page
    And the mailout called "My Mailout" should be in the "confirmed" state

  Scenario: Listing incomplete mailouts
    Given I am logged in
    And there is a mailout "My Mailout" with group "Public" that has been scheduled
    When I go to the mailouts page
    Then I should see "My Mailout"
    And I should see "Confirm mailout"

  Scenario: Viewing an incomplete mailout
    Given I am logged in
    And there is a message called "My Message" in the system
    And there is a mailout "My Mailout" with message "My Message" and group "Public" that has been scheduled
    When I go to the mailouts page
    And I follow "My Mailout"
    Then I should be on the show page for "Mailout" with a "title" of "My Mailout"
    And I should see "Mailout: My Mailout"
    And I should see "Message Details"
    And I should see "Title"
    And I should see "My Message"
    And I should see "Type"
    And I should see "Plain Text"
    And I should see "Source"
    And I should see "Directly Edited"
    And I should see "Individual Recipients"
    And I should see "Group Recipients"
    And I should see "Public"
    And I should not see "Remove"
    And I should see "Delivery Data"
    And I should see "Due Date"

  Scenario: Continuing an incomplete email
    Given I am logged in
    And there is a message called "My Message" in the system
    And there is a mailout in the system called "My Mailout" with "My Message" as it's message
    And the mailout "My Mailout" is in the "schedule_mailout" state
    When I go to the mailouts page
    And I follow "Continue"
    Then I should be on the edit page for "Mailout" with a "title" of "My Mailout"

  Scenario: Seeing that a mailout is ready to send
    Given I am logged in
    And there is a message called "My Message" in the system
    And there is a mailout in the system called "My Mailout" with "My Message" as it's message
    And the mailout "My Mailout" is in the "confirmed" state
    When I go to the mailouts page
    Then I should see "Ready to Send"
