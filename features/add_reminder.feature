Feature: Login feature

  Scenario: As a valid user I can log into my app
    When I press view with id "add_reminder"
    Then I should see "Add Reminder"
    Then I enter text "go to the bed" into field with id "reminder_title"
    Then I press view with id "save_reminder"
    Then I wait up to 5 seconds to see "go to the bed"
    Then I wait for 1 second
    Then I take a screenshot
