gem "mysql2"

after_bundler do
  say_wizard "Mysql recipe running"
  remove_file 'db/development.sqlite3'
  remove_file 'config/database.yml'
  create_file 'config/database.yml' do
    begin
      mysql_config = File.open( ENV["HOME"] + '/.rails_configs/mysql.yml' ){ |yf| YAML::load( yf ) }
puts  ENV["HOME"] + '/.rails_configs/mysql.yml'
puts mysql_config.inspect
    rescue Exception => e
      raise "Couldn't find the mysql.yml file - check if the folder ~/.rails_configs exists"
    end
  <<-YAML
standard: &standard
  encoding: #{mysql_config['encoding']}
  adapter: #{mysql_config['adapter']}
  port: #{mysql_config['port']}
  username: #{mysql_config['username']}
  password: #{mysql_config['password']}
  host: #{mysql_config['host']}

development:
  <<: *standard
  database: #{app_name}_dev

test: &test
  <<: *standard
  database: #{app_name}_test

production:
  <<: *standard
  database: #{app_name}_production

YAML
  end

end

# after_bundler do

#   say_wizard "HomePageUsers recipe running 'after bundler'"

#   # Modify the home controller
#   gsub_file 'app/controllers/home_controller.rb', /def index/ do
#   <<-RUBY
# def index
#   @users = User.all
# RUBY
#   end

#   # Replace the home page
#   if recipes.include? 'haml'
#     remove_file 'app/views/home/index.html.haml'
#     # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
#     # We have to use single-quote-style-heredoc to avoid interpolation.
#     create_file 'app/views/home/index.html.haml' do 
#     <<-'HAML'
# %h3 Home
# - @users.each do |user|
#   %p User: #{user.name}
# %p = debug params
# HAML
#     end
#   else
#     append_file 'app/views/home/index.html.erb' do <<-ERB
# <h3>Home</h3>
# <% @users.each do |user| %>
#   <p>User: <%= user.name %></p>
# <% end %>
# ERB
#     end
#   end

# end

__END__

name: Mysql
description: "Use Mysql as a default database"
author: phocke

category: other
tags: [utilities, configuration]
