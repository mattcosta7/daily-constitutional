# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :environment, :development
#
every 10.minutes do
  rake "update_all_blogs"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: 
