Feature: Environment tasks

  Scenario: Successful deployment

    Given a development environment
    When I run "development:deploy"
    Then heroploy should invoke "development:check:all"
    And heroploy should invoke "development:push"
    And heroploy should invoke "development:config"
    And heroploy should invoke "development:db:migrate"
    And heroploy should invoke "development:tag"

  Scenario: Failing build check
  
    Given a staging environment
    And I am on master
    When the travis build is failing
    And I run "staging:deploy"
    Then the task should fail with "Failing Travis build for branch master"