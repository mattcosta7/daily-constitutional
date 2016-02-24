desc "This task is called by the Heroku scheduler add-on"
task :update_all_entries => :environment do
  puts "Updating feed..."
  Blog.update_all_entries
  puts "done."
end