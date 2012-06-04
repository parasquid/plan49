require "bundler/capistrano"
load "config/recipes/base"

set :application, "Plan49"
set :repository,  "git@github.com:parasquid/plan49.git"
default_run_options[:pty] = true
set :user, "tristan"
set :server_name, 'plan49.com'

# so there is no need to add specific server keys
ssh_options[:forward_agent] = true
namespace :ssh do 
  task :start_agent do 
    `ssh-add` 
  end 
end
before 'deploy:update_code', 'ssh:start_agent' 

default_run_options[:pty] = true

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_via, :remote_cache
set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false

role :web, "108.174.55.115"                          # Your HTTP server, Apache/etc
role :app, "108.174.55.115"                          # This may be the same as your `Web` server
role :db,  "108.174.55.115", :primary => true # This is where Rails migrations will run
role :db,  "108.174.55.115"
set :port, 20022

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :restart do
    run "#{sudo} service thin stop"
    run "#{sudo} service thin start"
  end
end