load 'deploy/assets'
default_run_options[:pty] = true

set :application, 'cloud_leagues'
set :user, 'max'
set :domain, 'cloudleagues.com'

set :scm, 'git'
set :scm_passphrase, 'tyranus2'
set :repository, 'git@github.com:4stocked/cloud_leagues.git'
set :branch, 'master'

role :web, domain
role :app, domain
role :db, domain, primary: true

set :deploy_to, '/var/www/vhosts/cloud_leagues'
set :deploy_via, :remote_cache

set :use_sudo, false
ssh_options[:forward_agent] = true
ssh_options[:keys] = %w(/Users/max/.ssh/id_rsa_ec2)

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

  desc 'Build missing paperclip styles'
  task :build_missing_paperclip_styles, roles: :app do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake paperclip:refresh:missing_styles"
  end
end

after('deploy:update_code', 'deploy:build_missing_paperclip_styles')
