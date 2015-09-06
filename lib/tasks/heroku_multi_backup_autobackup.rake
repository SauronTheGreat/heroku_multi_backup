namespace :heroku_multi_backup do
  desc 'Description for rake task'

  task :autobackup  do
    Autobackup.call
  end
end
