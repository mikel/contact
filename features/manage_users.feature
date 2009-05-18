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
    Then I should see "bsmith"
  
  Scenario: One user plus the admin user in the system
    Given I am logged in as an admin
    And a user with username "Charles" and password "PassWord"
    When I go to the users page
    Then I should see "Charles"
    And I should see "bsmith"

  Scenario: Going to the new user page
    Given I am logged in as an admin
    When I go to the users page
    And I follow "New User"
    Then I should be on the new user page

  Scenario: Making a new user
    Given I am logged in as an admin
    When I go to the new user page
    And I fill in "login" with "mlindsaar"
    And I fill in "given name" with "Mikel"
    And I fill in "family name" with "Lindsaar"
    And I fill in "email" with "mikel@me.com"
    And I fill in "password" with "1234abcd"
    And I fill in "password confirmation" with "1234abcd"
    And I press "Create"
    Then I should be on the users page
    And I should see "User mlindsaar successfully created"
    And I should see "Mikel"
    And I should see "Lindsaar"

  Scenario: Making an invalid user
    Given I am logged in as an admin
    When I go to the new user page
    And I fill in "login" with "mlindsaar"
    And I fill in "given name" with "Mikel"
    And I fill in "family name" with "Lindsaar"
    And I fill in "password" with "1234abcd"
    And I fill in "password confirmation" with "1234abcd"
    And I press "Create"
    Then I should not see "Errors"

  Scenario: Editing a user in the system
    Given I am logged in as an admin
    When I go to the users page
    And I follow "edit"
    Then I should be on the edit user page for "bsmith"
    And the "login" field should contain "bsmith"
    And the "given name" field should contain "Bob"
    And the "family name" field should contain "Smith"

  Scenario: Changing a user in the system
    Given I am logged in as an admin
    When I go to the edit user page for "bsmith"
    And I fill in "login" with "sammy_jones"
    And I fill in "email" with "sammy@you.com"
    And I fill in "given name" with "Sammy"
    And I fill in "family name" with "Jones"
    And I press "Update"
    Then I should be on the users page
    And I should see "Update Successful"
    And I should see "sammy_jones"
    And I should see "Sammy"
    And I should see "Jones"

  Scenario: Deleting a user
    Given I am logged in as an admin
    And a user with username "Charles" and password "PassWord"
    When I go to the users page
    And I click the delete link for "Charles"
    Then I should be on the users page
    And I should see "Deleted user Charles successfully"
    And I should not see "Charles@someplace.com"

  Scenario: Making a user an admin
    Given I am logged in as an admin
    And a user with username "Charles" and password "PassWord"
    When I go to the edit user page for "Charles"
    And I check "Admin"
    And I press "Update"
    Then there should be 2 administrators in the system

  Scenario: Removing admin rights from a user
    Given I am logged in as an admin
    And a user with username "Charles" and password "PassWord"
    And "Charles" is an "admin"
    When I go to the edit user page for "Charles"
    And I uncheck "Admin"
    And I press "Update"
    Then there should be 1 administrator in the system
  
  Scenario: Trying to delete the last administrator
    Given I am logged in as an admin
    When I go to the users page
    And I click the delete link for "bsmith"
    Then I should be on the users page
    And I should see "Can not delete the last administrator"
  
  Scenario: User editing their own profile
    Given I am logged in
    When I go to the edit user page for "bsmith"
    Then the "login" field should be disabled
    And I should not see "admin"
  
  Scenario: User updating their own profile
    Given I am logged in
    When I go to the edit user page for "bsmith"
    And I fill in "email" with "sammy@you.com"
    And I fill in "given name" with "Sammy"
    And I fill in "family name" with "Jones"
    And I press "Update"
    Then I should be on the homepage
    And I should see "Successfully updated profile"
