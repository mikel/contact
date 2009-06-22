Feature: Home page
  In order to know what to do and how to get there
  As an user
  I want a home page that gives me relevant links and information
  
  Scenario: going to the home page as a user
    Given I am logged in
    When I go to the homepage
    Then I should be on the homepage
    And I should see "Welcome to Contact"
    And I should see "Profile"
  
  Scenario: going to the home page as an administrator
    Given I am logged in as an admin
    When I go to the homepage
    Then I should be on the homepage
    And I should see "Welcome to Contact"
    And I should see "Users"
