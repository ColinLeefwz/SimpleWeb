# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Expert.create(name: 'Alessandro Duina',
			  image_url: 'AD pic.jpg',
			  company: 'Prodygia',
			  title: 'Co-Founder'
			  )


Expert.create(name: 'Guillaume Maury',
			  image_url: 'guillaume profile pic.jpg',
			  company: 'Prodygia',
			  title: 'Founder')