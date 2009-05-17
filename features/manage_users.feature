Feature: Managing users
  In order to get people to use the software
  As an administrator
  I want the ability to add, edit and delete users

  Scenario: Trying to access the users page when not an admin
    Given I am logged in
    When I go to the users page
    Then I should be on the homepage
    And I should see "You must be an administrator to access this page"
    
  Scenario: Only the admin user defined
    Given I am logged in as an admin
    When I go to the users page
    Then I should see "Bob"
  
  Scenario: One user plus the admin user in the system
    Given I am logged in as an admin
    And a user with username "Charles" and password "PassWord"
    When I go to the users page
    Then I should see "Charles"
    And I should see "Bob"

  Scenario: Editing a user in the system
    Given I am logged in as an admin
    When I go to the users page
    And I follow "edit"
    Then I should be on the edit user page for "Bob"
