FactoryGirl.define do
  factory :environment_checks, :class => Heroploy::Config::EnvironmentChecks do
    pushed false
    staged false
    branch nil
    
    trait :development do
      pushed false
      staged false
      branch nil
    end
    
    trait :staging do
      pushed true
      staged false
      branch 'master'
    end
    
    trait :production do
      pushed true
      staged true
      branch 'master'
    end
  end
  
  factory :environment, :class => Heroploy::Config::Environment do    
    checks { build(:environment_checks) }
    
    [:development, :staging, :production].each do |t|
      trait t do
        name t.to_s
        remote t.to_s
        checks { build(:environment_checks, t) }
      end
    end
  end
  
  factory :deployment_config, :class => Heroploy::Config::DeploymentConfig do
    environments {
      [
        build(:environment, :development),
        build(:environment, :staging),
        build(:environment, :production)
      ]
    }
  end
  
  factory :travis_build, :class => Travis::Client::Build do
    [:passed, :failed].each do |t|
      trait t do
        after(:build) do |build|
          build.state = t.to_s
        end
      end
    end
  
    initialize_with { Travis::Client::Build.new(Travis::Client::Session.new, 123) }
  end
  
  factory :travis_repo, :class => Travis::Client::Repository do
    initialize_with { Travis::Client::Repository.new(Travis::Client::Session.new, 123) }
  end
end
