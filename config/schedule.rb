# Use this file to easily define all of your cron jobs.
env :PATH, ENV['PATH']
set :chronic_options, hours24: true
# set :environment, 'development'
set :output, 'log/cron.log'
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 4.day, at: '23:59' do
  rake 'cleanup:unnattached_files'
end
