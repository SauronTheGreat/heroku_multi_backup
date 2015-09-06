require "heroku/command/pg"
require "heroku/command/pg_backups"
require "heroku/api"
require "tmpdir"
require 'aws-sdk'



class Autobackup
  attr_reader :client
  attr_accessor :backup_url, :created_at
  def self.call
    new.call
  end


  def initialize(attrs={})
    Heroku::Command.load
    Heroku::Auth.credentials = [ ENV['HEROKU_USERNAME'], ENV['HEROKU_API_KEY'] ]


  end

  def call
    # initialize the heroku client interface
    ENV['APPNAME'].split(",").each do |app|
      execute_backup(app)
    end
  end

  def execute_backup(appname)
    puts "================================="
    puts "Starting back up for "+appname

    @client = Heroku::Command::Pg.new([], :app =>appname)
    # database is standard database_url but is configurable in case the app has multiple DBs
    begin
      attachment = client.send(:generate_resolver).resolve(database)

      # Actual backup interface to heroku
      backup = client.send(:hpg_client, attachment).backups_capture
      client.send(:poll_transfer, "backup", backup[:uuid])
      puts "Backup complete ..."
      # get the public url of the backup file for uploading to S3
      self.backup_url = Heroku::Client::HerokuPostgresqlApp
      .new(appname).transfers_public_url(backup[:num])[:url]
      download_file(appname)

      puts "Back up for "+ appname + " complete"
      puts "================================="
    rescue
      puts "The application "+ appname + "is not accessible to you"
    end

  end

  def download_file(dbname)
    puts "Downloading file in local system"
    # download the file from heroku and save it into a temp file
    File.open(temp_file, "wb") do |output|
      streamer = lambda do |chunk, remaining_bytes, total_bytes|
        output.write chunk
      end

      # https://github.com/excon/excon/issues/475
      Excon.get backup_url,
        :response_block    => streamer,
        :omit_default_port => true
    end
    # initiate upload to S3
    puts "Download complete..."
    upload_file(temp_file,dbname)
  end


  def upload_file(filepath,dbname)
    # code for actual s3 upload
    puts "Uploading file in S3..."
    Aws.config.update({
                        region: 'ap-southeast-1',
                        credentials: Aws::Credentials.new(ENV['S3_ACCESS_ID'],ENV['S3_ACCESS_SECRET'])

    })
    s3 = Aws::S3::Resource.new(region:ENV['S3_REGION'])
    obj = s3.bucket(ENV['S3_BUCKET']).object(generate_file_name(dbname))
    obj.upload_file(filepath)
    puts "Upload Complete"
  end



  private
  def database
    "DATABASE_URL"
  end

  def temp_file
    "#{Dir.tmpdir}/pgbackup"
  end
  def current_timestamp
    Time.now.getutc.to_i
  end
  def current_time
    Time.now.getutc.to_s
  end

  def generate_file_name(dbname)
    'backup_for_'+dbname+"_"+current_timestamp.to_s+"("+current_time+")"

  end

end