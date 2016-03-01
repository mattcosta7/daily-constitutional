# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# if Category.all.length == 0
#   cats = ['Art',
#     'Economics',
#     'Parenting',
#     'Career',
#     'Finance',
#     'Gaming',
#     'Nature',
#     'Wine',
#     'Beer',
#     'Medicine',
#     'Sports',
#     'Science',
#     'Technology',
#     'Business',
#     'Photography',
#     'Law',
#     'Wedding',
#     'Travel',
#     'Music',
#     'Other'
#   ]

#   cats.each do |title|
#     Category.create(title: title)
#   end
# end

# if User.all.length < 10
#   100.times do |guy|
#     user = User.new(email: Faker::Internet.email, password:'123456', password_digest: '123456', location: Faker::Internet.ip_v4_address)
#     user.save
#   end
# end


for i in 3...User.all.length
  x = rand(Blog.all.length)
  y = rand(Blog.all.length-1) + 1
  x.times do |something|
    User.find(i).blogs << Blog.find(y) unless User.find(i).blogs.include?(Blog.find(y))
  end
end