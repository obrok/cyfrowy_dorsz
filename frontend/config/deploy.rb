set :application, "cyfrowy_dorsz"
set :repository,  "git@github.com:obrok/cyfrowy_dorsz.git"
set :scm, :git
ssh_options[:forward_agent] = true
set :deploy_to, "/home/obrok/ruby/obrok.rootnode.net/#{application}"
set :use_sudo, false
set :user, "obrok"

role :web, "s2.rootnode.net"
role :app, "s2.rootnode.net"
role :db,  "s2.rootnode.net", :primary => true

after 'deploy:update_code', 'deploy:copy_configuration'

namespace :deploy do
  task :start do ; end
  task :stop do ; end

  desc "Link in the production extras and Migrate the Database"
  task :copy_configuration do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/frontend/config/database.yml"
    run "ln -nfs #{shared_path}/log #{release_path}/frontend/log"
    deploy.migrate
  end

  desc "Restart server"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Migrate database"
  deploy.task :migrate do
    run "cd #{release_path}/frontend; bundle exec rake sequel:db:migrate MERB_ENV=production"
  end
end
