Feature: Deployment tasks

  Scenario: Successful deployment

    Given a development environment
    When I run "development:deploy"
    Then heroploy should invoke "development:check:all"
    And heroploy should invoke "development:push"
    And heroploy should invoke "development:config"
    And heroploy should invoke "development:db:migrate"
    And heroploy should invoke "development:tag"
