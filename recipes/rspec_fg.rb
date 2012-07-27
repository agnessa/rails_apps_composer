gem 'rspec-rails', :group => [:development, :test]
gem 'factory_girl_rails', :group => [:development, :test]

# note: there is no need to specify the RSpec generator in the config/application.rb file

after_bundler do
  say_wizard "RSpec recipe running 'after bundler'"
  generate 'rspec:install'

  say_wizard "Include FactoryGirl syntax methods"
  inject_into_file 'spec/spec_helper.rb', :after => "RSpec.configure do |config|\n" do <<-RUBY

  config.include FactoryGirl::Syntax::Methods

RUBY
  end

  say_wizard "Create .rspec file"
  remove_file ".rspec"
  create_file ".rspec" do
<<-CONF
--colour
--format documentation
CONF
  end

  say_wizard "Create .travis.yml file"
  create_file ".travis.yml" do
<<-CONF
language: ruby
rvm:
  - 1.9.3
before_script:
  - psql -c 'create database #{app_name}_test' -U postgres
  - RAILS_ENV=test bundle exec rake db:migrate
script: 
  - bundle exec rspec spec
CONF
  end

  say_wizard "Removing test folder (not needed for RSpec)"
  run 'rm -rf test/'

  inject_into_file 'config/application.rb', :after => "Rails::Application\n" do <<-RUBY

    # don't generate RSpec tests for views and helpers
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
    end

RUBY
  end
end

__END__

name: RSpec_fg
description: "Use RSpec with FactoryGirl"
author: agnessa

exclusive: unit_testing
category: testing

