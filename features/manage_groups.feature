Feature: Manage Groups
  In order to have a group of recipients to send messages to
  As a user
  I want to be able to modify and manage groups of recipients

  Scenario: Not being logged in and trying to make a group
    Given I am logged out
    When I go to the groups page
    Then I should be on the login page
  
  Scenario: No groups in the system
    Given I am logged in
    When I go to the groups page
    Then I should see "No groups defined"
    And I should see "Make a new group"

  Scenario: Creating a new group
    Given I am logged in
    And I am on the homepage
    When I follow "Groups"
    And I follow "Make a new group"
    And I fill in "Name" with "Public"
    And I press "Create"
    Then I should be on the groups page
    And I should see "Public"


