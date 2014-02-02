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
end
