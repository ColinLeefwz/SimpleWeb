# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Expert.delete_all
Session.delete_all

Expert.create(name: 'Alessandro Duina',
			  image_url: 'AD pic.jpg',
			  company: 'Prodygia',
			  title: 'Co-Founder'
			  )


Expert.create(name: 'Guillaume Maury',
			  image_url: 'guillaume profile pic.jpg',
			  company: 'Prodygia',
			  title: 'Founder')


Session.create(expert_id: 1, title: "Entry China Road", description: "Lala Lala", location: "shanghai", status: "upcomming")


Session.create(expert_id: 2, title: "Rails Agile Dev", description: "BiuBiu BiuBiu", location: "beijing", status: "scheduled")
