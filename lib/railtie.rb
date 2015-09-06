if defined?(Rails)
  if Rails.version < "3"
    load "tasks/heroku_multi_backup_autobackup.rake"
  else
    module HerokuMultiBackup
      class Railtie < Rails::Railtie
        rake_tasks do
          load "tasks/heroku_multi_backup_autobackup.rake"
        end
      end
    end
  end
end