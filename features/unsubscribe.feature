Feature: Unsubscribe
  In order to be able to unsubscribe from future mailings
  As a recipient
  I want to be able to do something to unsubscribe

  Scenario: sending out an email to one user
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is one multipart mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the recipient "Mikel Lindsaar"
    When I tell the system to send
    Then there should be an unsubscribe link for "Mikel Lindsaar" in the email

  Scenario: sending out an email to one user
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is a recipient I added in the system called "Ada Lindsaar"
    And there is one multipart mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the recipient "Mikel Lindsaar"
    And the mailout "My Mailout" has the recipient "Ada Lindsaar"
    When I tell the system to send
    Then there should be an unsubscribe link for "Mikel Lindsaar" in the email
    And there should be an unsubscribe link for "And Lindsaar" in the email
