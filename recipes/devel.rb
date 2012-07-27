gem 'ruby-debug19', :group => [:development]

after_bundler do
  say_wizard "Devel recipe running 'after bundler'"
  say_wizard "Create .gitignore"
  remove_file '.gitignore'
  create_file 'gitignore.rb' do
<<-GITIGNORE
# Ignore bundler config
/.bundle

# Ignore all logfiles and tempfiles.
/rdoc
/log/*.log
/tmp
/public/system

# Ruby
/vendor/ruby

# VIM
*.swp
*.un~

# OS X
*.DS_Store

# Netbeans and other IDE’s
/nbproject
.project
.idea/
GITIGNORE
  end

  say_wizard "Create README.md"
  remove_file "README.rdoc"
  create_file "README.md" do
    <<-README
##{app_name} [![Build Status](https://secure.travis-ci.org/unepwcmc/SAPI.png?branch=master)](http://travis-ci.org/unepwcmc/#{app_name})
This is the generic README of the #{app_name} project. Watch out for some awesomeness to come.

##Dependencies
##Installation
##Usage
    README
  end

end
__END__

name: Devel
description: "Use some devel conventions"
author: agnessa

category: other
tags: [utilities, configuration]

