FactoryGirl.define do
  factory :checks_config do
    pushed true
    branch 'master'
    staged true
  end
  
  factory :env_config do
    name 'production'
    remote 'production'
    checks { build(:checks_config) }
  end
  
  factory :deploy_config do
    environments { build_list(:env_config, 1) }
  end
end
