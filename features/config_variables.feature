Feature: Config variables

  Scenario: Set config variables
  
    Given a development environment with variables:
      """
      foo: bar
      """
    When I run "development:config"
    Then heroploy should execute "heroku config:set foo=bar --app my-development-app"
  
  Scenario: Set shared config variables
  
    Given a development environment with variables:
      """
      foo: bar
      """
    And a shared environment with variables:
      """
      fizz: buzz
      """
    When I run "development:config"
    Then heroploy should execute "heroku config:set fizz=buzz foo=bar --app my-development-app"
  
  