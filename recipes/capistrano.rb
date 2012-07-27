gem 'capistrano', :group => [:development]
gem 'capistrano-ext', :group => [:development]
gem 'brightbox', :group => [:development]

after_bundler do
  say_wizard "Capistrano recipe running 'after bundler'"
  run 'capify .'
  remove_file 'config/deploy.rb'
  create_file 'config/deploy.rb' do
<<-DEPLOY
set :default_stage, 'staging'
require 'capistrano/ext/multistage'
gem 'brightbox', '>=2.3.9'
require 'brightbox/recipes'
require 'brightbox/passenger'

set :application, "#{app_name}"

set(:deploy_to) { File.join("", "home", user, application) }

set :repository,  "git@github.com:unepwcmc/#{app_name}.git"
set :scm, :git
set :scm_username, "unepwcmc-read"
set :deploy_via, :remote_cache

set :local_shared_files, %w(config/database.yml)

default_run_options[:pty] = true

task :setup_production_database_configuration do
  the_host = Capistrano::CLI.ui.ask("Database IP address: ")
  database_name = Capistrano::CLI.ui.ask("Database name: ")
  database_user = Capistrano::CLI.ui.ask("Database username: ")
  pg_password = Capistrano::CLI.password_prompt("Database user password: ")

  require 'yaml'

  spec = {
    "#\{rails_env\}" => {
      "adapter" => "postgresql",
      "database" => database_name,
      "username" => database_user,
      "host" => the_host,
      "password" => pg_password
    }
  }

  run "mkdir -p #\{shared_path\}/config"
  put(spec.to_yaml, "#\{shared_path\}/config/database.yml")
end
after "deploy:setup", :setup_production_database_configuration

DEPLOY
  end

  create_file "config/deploy/staging.rb" do
    'set :rails_env, "staging"'
  end
  create_file "config/deploy/production.rb" do
    'set :rails_env, "production"'
  end

end
__END__

name: Capistrano
description: "Use Capistrano with a multistage setup"
author: agnessa

category: other
tags: [utilities, configuration]

