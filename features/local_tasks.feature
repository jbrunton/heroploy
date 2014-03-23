Feature: Local environment

  Scenario: Default run script
  
    Given a local environment with variables:
      """
        foo: bar
      """
    When I run "local:run"
    Then heroploy should execute "bundle exec foo=bar rails s"
