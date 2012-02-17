set :application, 'cloud_leagues'
set :deploy_to, '/var/www/vhosts/cloud_leagues'

set :repository,  '.'
set :scm, :none
set :deploy_via, :copy

set :user, 'max'
set :use_sudo, false

server 'ec2-107-21-192-108.compute-1.amazonaws.com', :web, :app, :db, primary: true

ssh_options[:keys] = [File.join(ENV['HOME'], '.ssh', 'id_rsa_ec2')]

# For Passenger
namespace :deploy do
  task :start do
  end

  task :stop do
  end

  desc 'Restart the application in Passenger'
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end
