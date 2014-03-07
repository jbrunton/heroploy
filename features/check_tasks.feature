Feature: Deployment checks

  Scenario: Failing build check

    Given a staging environment
    When the travis build is failing
    And I have "master" checked out
    And I run "staging:deploy"
    Then the task should fail with "Failing Travis build for branch master"
  
  Scenario: Failing branch check

    Given a staging environment
    When I have "my-development-branch" checked out
    And I run "staging:deploy"
    Then the task should fail with "Cannot deploy branch my-development-branch to staging"
  
  Scenario: Failing remote check

    Given a staging environment
    When I have "master" checked out
    And my branch is ahead of origin
    And I run "staging:deploy"
    Then the task should fail with "Branch master is behind origin/master"
  
  Scenario: Failing staged check

    Given a production environment
    And a staging environment
    When I have "master" checked out
    And my branch is ahead of staging
    And I run "production:deploy"
    Then the task should fail with "Changes not yet staged on staging"
