# HerokuMultiBackup

The aim of this gem is to create backup of databases from on Heroku and upload it on Amazon S3. The gem is a very simple container of a rake task which can be executed manually or a scheduler can be used.

Initially heroku used to provide a back up add-on which has been now discountinued in favour of the pg backup service ([check here](https://devcenter.heroku.com/articles/heroku-postgres-backups)). 
The problem I faced was when we have multiple applications on heroku, the service has to be executed for all the applications. Also there is no automated way of doing this and hence the rake task is created.
In this gem, one can specify all the applications the backup is required and the heroku user credentials in the environment variables and if the user has permission to access the app, backup will be taken. Detailed usage is given below:

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heroku_multi_backup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heroku_multi_backup

## Usage

To use this gem on heroku, add the environment variables using 
```ruby
heroku config:set somevar=someval
```
On the local development system , I personally use [foreman](https://github.com/ddollar/foreman) and use env file to specify the variables.
A sample env file:
```ruby
S3_ACCESS_ID=******
#Access Id for Amazon S3 server
S3_ACCESS_SECRET=****
#Access secret for Amazon S3 server
S3_REGION=****
#Region of your Amazon S3 server
S3_BUCKET=****
#Name of the bucket you want the backup files to be uploaded to
APPNAME=app1,app2,app3
#List of all applications whose backup has to be taken
HEROKU_USERNAME=me@myemail.com
#Username for heroku
HEROKU_API_KEY=*****
#API key for heroku
#NOTE: Username and api key are used for authentication and checking if user has access to all apps listed.
```
Once this is done run the rake task as:
```ruby
 rake heroku_multi_backup:autobackup
```
If you are using foreman use:
```ruby
 foreman run rake heroku_multi_backup:autobackup
```
And voila ! Files will be uploaded to your bucket.

##TODO

 - Add tests.
 - Add support fr dropbox .
 - Add support for google drive.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/heroku_multi_backup/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

##References
I must accept that the idea for this gem has come using [pgbackup-archive gem](https://github.com/kjohnston/pgbackups-archive) and I have also used his code as reference.

