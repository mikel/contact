Feature: Recipient Viewing Tracking
  In order to know who of our recipients viewed an email
  As an user
  I want the system to record who looked at what

  Scenario: Tracking a clicked email link
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is one plain text mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the recipient "Mikel Lindsaar"
    When I tell the system to send
    And I go and visit the url for the "My Mailout" email for "Mikel Lindsaar"
    Then the system should record that "Mikel Lindsaar" read the email

  Scenario: Tracking a clicked email link for more than one user
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is a recipient I added in the system called "Ada Lindsaar"
    And there is one plain text mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the recipient "Mikel Lindsaar"
    And the mailout "My Mailout" has the recipient "Ada Lindsaar"
    When I tell the system to send
    And I go and visit the url for the "My Mailout" email for "Mikel Lindsaar"
    Then the system should record that "Mikel Lindsaar" read the email
    And the system should record that "Ada Lindsaar" read the email

  Scenario: Tracking a opened email by it's images
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is one multipart mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the recipient "Mikel Lindsaar"
    When I tell the system to send
    And I go and visit the url for the "My Mailout" email for "Mikel Lindsaar"
    Then the system should record that "Mikel Lindsaar" read the email

  Scenario: Tracking a opened email by it's images for more than one user
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is a recipient I added in the system called "Ada Lindsaar"
    And there is one multipart mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the recipient "Mikel Lindsaar"
    And the mailout "My Mailout" has the recipient "Ada Lindsaar"
    When I tell the system to send
    And I go and visit the url for the "My Mailout" email for "Mikel Lindsaar"
    Then the system should record that "Mikel Lindsaar" read the email
    And the system should record that "Ada Lindsaar" read the email

