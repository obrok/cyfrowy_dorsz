require 'bundler/capistrano'

set :application, "cyfrowy_dorsz"
set :repository,  "git@codegarden.icsadl.agh.edu.pl:cyfrowy_dorsz"
set :scm, :git
set :deploy_to, "/home/ankieter/#{application}"
set :use_sudo, false
set :user, "ankieter"

role :web, "codegarden.icsadl.agh.edu.pl"
role :app, "codegarden.icsadl.agh.edu.pl"
role :db,  "codegarden.icsadl.agh.edu.pl", :primary => true

after 'deploy:update_code', 'deploy:copy_configuration'

namespace :deploy do
  task :start do ; end
  task :stop do ; end

  desc "Link in the production extras and Migrate the Database"
  task :copy_configuration do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/log #{release_path}/log"
    deploy.migrate
  end

  desc "Restart server"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Migrate database"
  deploy.task :migrate do
    run "cd #{release_path}; bundle exec rake sequel:db:migrate MERB_ENV=production"
  end
end