desc 'update all blogs'
task update_all_blogs: :environment do
  # ... set options if any
  Blog.update_all_entries
end