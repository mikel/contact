Feature: Manage Recipients
  In order to be able to send an email to our public
  As a user
  I want to be able to manage recipients
  
  Scenario: Not being logged in and trying to access recipients
    Given I am logged out
    When I go to the recipients page
    Then I should be on the login page
  
  Scenario: No recipients in the system
    Given I am logged in
    When I go to the recipients page
    Then I should see "Add a recipient"
    And I should not see "Edit"
    And I should not see "Delete"
  
  Scenario: One recipient in the system
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    When I go to the recipients page
    Then I should see "Mikel Lindsaar"
    And I should see "Edit"
    And I should see "Delete"
  
  Scenario: Going to the new recipient page
    Given I am logged in
    When I go to the recipients page
    And I follow "Add a recipient"
    Then I should be on the new recipient page
  
  Scenario: Adding a new recipient
    Given I am logged in
    And I am on the new recipient page
    When I fill in "Given Name" with "Mikel"
    And I fill in "Family Name" with "Lindsaar"
    And I press "Create"
    Then I should be on the recipients page
    And I should see "Mikel Lindsaar"
  
  Scenario: Editing a recipient
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And I am on the recipients page
    When I follow "Edit"
    Then I should be on the edit page for recipient "Mikel Lindsaar"
    And I should see "Editing Mikel Lindsaar"
  
  Scenario: Updating a recipient
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And I am on the recipients page
    When I follow "Edit"
    And I fill in "Given Name" with "Billy"
    And I fill in "Family Name" with "Joel"
    And I press "Update"
    Then I should be on the recipients page
    And I should see "Billy Joel"

  Scenario: Black Listing a recipient
    Given I am logged in
    And no recipients in the system
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And I am on the recipients page
    When I follow "Black List"
    Then I should be on the recipients page
    And I should see "Recipient successfully black listed"
    And there should be 1 recipient in the system
    And "Mikel Lindsaar" should be black listed

  Scenario: Deleting a recipient
    Given I am logged in
    And no recipients in the system
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And I am on the recipients page
    When I follow "Delete"
    Then I should be on the recipients page
    And I should see "Recipient successfully deleted"
    And there should be 0 recipients in the system
