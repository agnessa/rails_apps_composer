gsub_file 'Gemfile', "gem 'sqlite3'\n", ""

gem "pg"

after_bundler do
  say_wizard "Pg recipe running 'after_bundler'"
  remove_file 'db/development.sqlite3'
  remove_file 'config/database.yml'
  create_file 'config/database.yml' do
<<-YAML
standard: &standard
  encoding: utf8
  adapter: postgresql
  pool: 5
  timeout: 5000
  username: postgres
  password: postgres

development:
  <<: *standard
  database: #{app_name}_dev

test: &test
  <<: *standard
  database: #{app_name}_test
YAML
  end

end

__END__

name: Pg
description: "Use PostgreSQL as a default database"
author: agnessa

category: other
tags: [utilities, configuration]
