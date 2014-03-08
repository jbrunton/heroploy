Feature: Database tasks

  Scenario: db:migrate
  
    Given a production environment
    When I run "production:db:migrate"
    Then heroploy should execute "heroku run rake db:migrate --app my-production-app"

  Scenario: db:reset
  
    Given a production environment
    When I run "production:db:reset"
    Then heroploy should execute "heroku pg:reset DATABASE --confirm my-production-app --app my-production-app"
  
  Scenario: db:seed
  
    Given a production environment
    When I run "production:db:seed"
    Then heroploy should execute "heroku run rake db:seed --app my-production-app"

  Scenario: db:recreate

    Given a production environment
    When I run "production:db:recreate"
    Then heroploy should invoke "production:db:reset"
    And heroploy should invoke "production:db:migrate"
    And heroploy should invoke "production:db:seed"
    