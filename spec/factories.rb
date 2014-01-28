FactoryGirl.define do
  factory :checks_config do
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
  
  factory :env_config do    
    checks { build(:checks_config) }
    
    [:development, :staging, :production].each do |t|
      trait t do
        name t.to_s
        remote t.to_s
        checks { build(:checks_config, t) }
      end
    end
  end
  
  factory :deploy_config do
    environments {
      [
        build(:env_config, :development),
        build(:env_config, :staging),
        build(:env_config, :production)
      ]
    }
  end
end
