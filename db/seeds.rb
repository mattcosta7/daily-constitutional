# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
cats = ['Art',
  'Economics',
  'Parenting',
  'Career',
  'Finance',
  'Gaming',
  'Nature',
  'Wine',
  'Beer',
  'Medicine',
  'Sports',
  'Science',
  'Technology',
  'Business',
  'Photography',
  'Law',
  'Wedding',
  'Travel',
  'Music',
  'Other'
]

cats.each do |title|
  Category.create(title: title)
end