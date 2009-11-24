Feature: Sending a Mailout
  In order to communicate with our public
  As an user
  I want the system to send out emails whenever I tell it to
  
  Scenario: No mailouts to send
    Given there are no mailouts to send
    And there are no deliveries in the system
    When I tell the system to send
    Then no deliveries should be made
  
  Scenario: One mailout to send
    Given I am logged in
    And there is one mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has a recipient called "Mikel Lindsaar"
    When I tell the system to send
    Then there should be 1 delivery
    And the recipient "Mikel Lindsaar" should have been delivered one email
    And the mailout called "My Mailout" should be in the "sent" state
  
  Scenario: Sending a mailout twice should only deliver to each person once
    Given I am logged in
    And there is one mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has a recipient called "Mikel Lindsaar"
    When I tell the system to send
    And I reset the mailout "My Mailout" to send again and send it
    Then there should be 1 delivery
    And the recipient "Mikel Lindsaar" should have been delivered one email
    And the mailout called "My Mailout" should be in the "sent" state
  
  Scenario: Sending a mailout to a group
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is a recipient I added in the system called "Ada Lindsaar"
    And there is a group called "Public"
    And "Mikel Lindsaar" belongs to "Public"
    And "Ada Lindsaar" belongs to "Public"
    And there is one mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the group "Public"
    When I tell the system to send
    Then there should be 2 deliveries
    And the recipient "Mikel Lindsaar" should have been delivered one email
    And the recipient "Ada Lindsaar" should have been delivered one email
    And the mailout called "My Mailout" should be in the "sent" state
  
  Scenario: Two mailouts to send, one now and one in the future
    Given I am logged in
    And there is a recipient I added in the system called "Mikel Lindsaar"
    And there is one mailout called "My Mailout" to be sent immediately
    And the mailout "My Mailout" has the recipient "Mikel Lindsaar"
    And there is one mailout called "My Other Mailout" to be sent one day from now
    And the mailout "My Other Mailout" has the recipient "Mikel Lindsaar"
    When I tell the system to send
    Then there should be 1 delivery
    And the recipient "Mikel Lindsaar" should have been delivered one email
    And the mailout called "My Mailout" should be in the "sent" state
    And the mailout called "My Other Mailout" should be in the "confirmed" state
  