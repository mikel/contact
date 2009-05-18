Feature: Manage sessions
  In order to limit access to authorized users
  an administrator
  wants to only allow authenticated users access
  
  Scenario: Unsuccessful login
    Given I am on the new user sessions page
    When I press "Login"
    Then I should see "You did not provide any details for authentication"

  Scenario: Non existent user
    Given I am on the new user sessions page
    When I fill in "login" with "bsmith"
    And I fill in "password" with "PassWord"
    And I press "Login"
    Then I should see "Login does not exist"

  Scenario: Incorrect password
    Given there is a user with username "bsmith" and password "PassWord"
    And I am on the new user sessions page
    When I fill in "login" with "bsmith"
    And I fill in "password" with "guess"
    And I press "Login"
    Then I should see "Password is not valid"

  Scenario: Successful login
    Given there is a user with username "bsmith" and password "PassWord"
    And I am on the new user sessions page
    When I fill in "login" with "bsmith"
    And I fill in "password" with "PassWord"
    And I press "Login"
    Then I should see "Login successful!"
    Then I should be on the homepage

  Scenario: Staying logged in
    Given I am logged in
    When I go to the homepage
    Then I should be on the homepage
  