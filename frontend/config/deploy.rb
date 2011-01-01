require 'bundler/capistrano'

set :application, "cyfrowy_dorsz"
set :repository,  "git@codegarden.icsadl.agh.edu.pl:cyfrowy_dorsz"
set :scm, :git
set :deploy_to, "/home/ankieter/#{application}/frontend/"

role :web, "codegarden.icsadl.agh.edu.pl:4000"
role :app, "codegarden.icsadl.agh.edu.pl:4000"
role :db,  "codegarden.icsadl.agh.edu.pl:4000", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end

  desc "Link in the production extras and Migrate the Database"
  task :after_update_code do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/merb.yml #{release_path}/config/merb.yml"
    run "ln -nfs #{shared_path}/log #{release_path}/log"
    deploy.migrate
  end

  desc "Restart server"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Migrate database"
  deploy.task :migrate do
    run "cd #{release_path}; rake sequel:db:migrate MERB_ENV=production"
  end
end