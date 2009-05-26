Feature: Manage Organizations
  In order to be able to track users by organizations
  As an administrator
  I want to be able to manage organizations
  
  Scenario: Not being logged in and trying to access organization management
    Given I am logged out
    When I go to the organizations page
    Then I should be on the login page
  
  Scenario: Not being logged in and trying to access organization management
    Given I am logged in
    When I go to the organizations page
    Then I should be on the homepage
    And I should see "You must be an administrator to access this page"
  
  Scenario: One organization in the system
    Given I am logged in as an admin
    And there is a organization I added in the system called "Sydney"
    When I go to the organizations page
    Then I should see "Sydney"
    And I should see "Edit"
    And I should see "Delete"
  
  Scenario: Going to the new organization page
    Given I am logged in as an admin
    When I go to the organizations page
    And I follow "New Organization"
    Then I should be on the new organization page
  
  Scenario: Adding a new organization
    Given I am logged in as an admin
    And I am on the new organization page
    When I fill in "Name" with "Sydney"
    And I press "Create"
    Then I should be on the organizations page
    And I should see "Sydney"
  
  Scenario: Editing an organization
    Given I am logged in as an admin
    And there is a organization I added in the system called "Sydney"
    And I am on the organizations page
    When I follow "Edit"
    Then I should be on the edit page for organization "Sydney"
  
  Scenario: Deleting an organization
    Given I am logged in as an admin
    And no organizations in the system
    And there is a organization I added in the system called "Sydney"
    And I am on the organizations page
    When I follow "Delete"
    Then I should be on the organizations page
    And I should see "Organization successfully deleted"
    And there should be 0 organizations in the system
