Feature: Viewing an email via a web server
  In order to be able to read the email in a non compliant browser
  As a recipient
  I want to be able to look at the email sent to me in my web browser
  
  Scenario: Plain text email
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is one plain text mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the recipient "Mikel Lindsaar"
    When I tell the system to send
    Then there should be one delivery
    And the delivery body should have "View this email in your web browser"
  
  Scenario: Multipart email
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is one multipart mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the recipient "Mikel Lindsaar"
    When I tell the system to send
    Then there should be one delivery
    And the delivery body should have "View this email in your web browser"
  
  Scenario: Sending an email to one person
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is one plain text mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the recipient "Mikel Lindsaar"
    When I tell the system to send
    Then there should be one delivery
    And the delivery body should have a url to view the email especially for "Mikel Lindsaar"

  Scenario: Sending an email to more than one person
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is a recipient I added in the system called "Ada Lindsaar"
    And there is one plain text mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the recipient "Mikel Lindsaar"
    And the mailout "My Mailout" has the recipient "Ada Lindsaar"
    When I tell the system to send
    Then there should be one delivery
    And the delivery body should have a url to view the email especially for "Mikel Lindsaar"
    And the delivery body should have a url to view the email especially for "Ada Lindsaar"
