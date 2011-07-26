#========================
#CONFIG
#========================
set :application, "photo"
set :appweb, "#{application}.mikhnova.ru"
set :repository,  "git@github.com:pomeo/#{appweb}.git"
set :user, "pomeo"
set :port, 2222
set :use_sudo, false
set :deploy_via, :copy
set :scm, :git
set :copy_exclude, ["/.git/", "/.gitignore", "/Capfile", "/config/", "/config.yaml", "/Rakefile", "Rules", "/tmp/", "/mkmf.log"]
#========================
#ROLES
#========================
role :web, "#{appweb}"
set :deploy_to, "/var/www/mikhnova.ru/#{application}/www"
set :deploy_user, "pomeo"
set :deploy_group, "pomeo"


